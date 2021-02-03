//
//  main.m
//  machoinfo
//
//  Created by xyj on 2021/2/3.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <mach-o/loader.h>
#include <mach-o/swap.h>
#include <mach-o/fat.h>

/* hack until arm64 headers are worked out */
#ifndef CPU_TYPE_ARM64
# define CPU_TYPE_ARM64            (CPU_TYPE_ARM | CPU_ARCH_ABI64)
#endif /* !CPU_TYPE_ARM64 */


extern void dump_segments(FILE *obj_file);

int main(int argc, char *argv[]) {
    if (argc < 2 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
        printf("Usage: %s <path to mach-o binary>\n", argv[0]);
        return 1;
    }
    const char *filename = argv[1];
    FILE *obj_file = fopen(filename, "rb");
    if (obj_file == NULL) {
        printf("'%s' could not be opened.\n", argv[1]);
        return 1;
    }
    dump_segments(obj_file);
    fclose(obj_file);
    
    (void)argc;
    return 0;
}

static uint32_t read_magic(FILE *obj_file, off_t offset) {
    uint32_t magic;
    fseek(obj_file, offset, SEEK_SET);
    fread(&magic, sizeof(uint32_t), 1, obj_file);
    return magic;
}

static int is_magic_64(uint32_t magic) {
    return magic == MH_MAGIC_64 || magic == MH_CIGAM_64;
}

static int should_swap_bytes(uint32_t magic) {
    return magic == MH_CIGAM || magic == MH_CIGAM_64 || magic == FAT_CIGAM;
}

static int is_fat(uint32_t magic) {
    return magic == FAT_MAGIC || magic == FAT_CIGAM;
}

struct _cpu_type_names {
    cpu_type_t cputype;
    const char *cpu_name; /* FIXME: -Wpadded from clang */
};

static struct _cpu_type_names cpu_type_names[] = {
    { CPU_TYPE_I386, "i386" },
    { CPU_TYPE_X86_64, "x86_64" },
    { CPU_TYPE_ARM, "arm" },
    { CPU_TYPE_ARM64, "arm64" }
};

static char * utostr(uint64_t X, bool isNeg) {
    
    char *Buffer = calloc(1, 21);
    
    if (X == 0) *--Buffer = '0';  // Handle special case...
    
    while (X) {
        char t = X % 10;
        *--Buffer = '0' + t;
        X /= 10;
    }
    
    if (isNeg) *--Buffer = '-';   // Add negative sign...
    return Buffer;
}

static char * getVersionString(uint32_t version) {
    uint32_t major = (version >> 16) & 0xffff;
    uint32_t minor = (version >> 8) & 0xff;
    uint32_t update = version & 0xff;
    
    char *Version = calloc(1, 32);
    char *str = utostr(major, false);
    char *str1 = utostr(minor, false);
    strcat(Version, str);
    strcat(Version, ".");
    strcat(Version, str1);
    if (update != 0) {
        strcpy(Version, ".");
        char *str2 = utostr(update, false);
        strcpy(Version, str2);
    }
    return Version;
}

static const char *cpu_type_name(cpu_type_t cpu_type) {
    static int cpu_type_names_size = sizeof(cpu_type_names) / sizeof(struct _cpu_type_names);
    for (int i = 0; i < cpu_type_names_size; i++ ) {
        if (cpu_type == cpu_type_names[i].cputype) {
            return cpu_type_names[i].cpu_name;
        }
    }
    
    return "unknown";
}

static void *load_bytes(FILE *obj_file, off_t offset, size_t size) {
    void *buf = calloc(1, size);
    fseek(obj_file, offset, SEEK_SET);
    fread(buf, size, 1, obj_file);
    return buf;
}

static const char * getBuildPlatform(uint32_t platform) {
    switch (platform) {
        case PLATFORM_MACOS: return "macos";
        case PLATFORM_IOS: return "ios";
        case PLATFORM_TVOS: return "tvos";
        case PLATFORM_WATCHOS: return "watchos";
        case PLATFORM_BRIDGEOS: return "bridgeos";
        case PLATFORM_MACCATALYST: return "macCatalyst";
        case PLATFORM_IOSSIMULATOR: return "iossimulator";
        case PLATFORM_TVOSSIMULATOR: return "tvossimulator";
        case PLATFORM_WATCHOSSIMULATOR: return "watchossimulator";
        case PLATFORM_DRIVERKIT: return "driverkit";
        default:
            return "";
    }
}

static void dump_dyld_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct dylinker_command *dyld = load_bytes(obj_file, actual_offset, sizeof(struct dylinker_command));
    if (is_swap) {
        swap_dylinker_command(dyld, 0);
    }
    const char *cmd_name;
    if (dyld->cmd == LC_ID_DYLINKER) {
        cmd_name = "LC_ID_DYLINKER";
    } else if (dyld->cmd == LC_LOAD_DYLINKER) {
        cmd_name = "LC_LOAD_DYLINKER";
    } else if (dyld->cmd == LC_DYLD_ENVIRONMENT) {
        cmd_name = "LC_DYLD_ENVIRONMENT";
    }
    
    if (dyld->name.offset >= dyld->cmdsize) {
        printf("LC: %d %s dyld: name ?(bad offset \"%d\" )\n", ncmds, cmd_name, dyld->name.offset);
    } else {
        
        char *P = load_bytes(obj_file, actual_offset + dyld->name.offset, dyld->cmdsize - dyld->name.offset);
        printf("LC: %d %s dyld: %s\n", ncmds, cmd_name, P);
        free(P);
    }
    free(dyld);
}

static void dump_dylib_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct dylib_command *dylid = load_bytes(obj_file, actual_offset, sizeof(struct dylib_command));
    if (is_swap) {
        swap_dylib_command(dylid, 0);
    }
    const char *cmd_name;
    if (dylid->cmd == LC_ID_DYLIB) {
        cmd_name = "LC_ID_DYLIB";
    } else if (dylid->cmd == LC_LOAD_DYLIB) {
        cmd_name = "LC_LOAD_DYLIB";
    } else if (dylid->cmd == LC_LOAD_WEAK_DYLIB) {
        cmd_name = "LC_LOAD_WEAK_DYLIB";
    } else if (dylid->cmd == LC_REEXPORT_DYLIB) {
        cmd_name = "LC_REEXPORT_DYLIB";
    } else if (dylid->cmd == LC_LAZY_LOAD_DYLIB) {
        cmd_name = "LC_LAZY_LOAD_DYLIB";
    } else if (dylid->cmd == LC_LOAD_UPWARD_DYLIB) {
        cmd_name = "LC_LOAD_UPWARD_DYLIB";
    }
    
    if (dylid->dylib.name.offset >= dylid->cmdsize) {
        printf("LC: %d %s dylid: name ?(bad offset \"%d\" )\n", ncmds, cmd_name, dylid->dylib.name.offset);
    } else {
        
        char *P = load_bytes(obj_file, actual_offset + dylid->dylib.name.offset, dylid->cmdsize - dylid->dylib.name.offset);
        printf("LC: %d %s dylid: %s\n", ncmds, cmd_name, P);
        free(P);
    }
    free(dylid);
}

static void dump_version_min_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct version_min_command *vd = load_bytes(obj_file, actual_offset, sizeof(struct version_min_command));
    if (is_swap) {
        swap_version_min_command(vd, 0);
    }
    const char *cmd_name;
    if (vd->cmd == LC_VERSION_MIN_MACOSX) {
        cmd_name = "LC_VERSION_MIN_MACOSX";
    } else if (vd->cmd == LC_VERSION_MIN_IPHONEOS) {
        cmd_name = "LC_VERSION_MIN_IPHONEOS";
    } else if (vd->cmd == LC_VERSION_MIN_TVOS) {
        cmd_name = "LC_VERSION_MIN_TVOS";
    } else if (vd->cmd == LC_VERSION_MIN_WATCHOS) {
        cmd_name = "LC_VERSION_MIN_WATCHOS";
    }
    
    if (vd->cmdsize != sizeof(struct version_min_command)) {
        printf(" Incorrect size\n");
    } else {
        uint32_t VersionOrSDK = vd->version;
        uint32_t major = (VersionOrSDK >> 16) & 0xffff;
        
        uint32_t VersionOrSDK1 = vd->version;
        uint32_t minor = (VersionOrSDK1 >> 8) & 0xff;
        
        printf("LC: %d %s version: %d.%d\n", ncmds, cmd_name, major, minor);
    }
    free(vd);
}

static void dump_note_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct note_command *Nt = load_bytes(obj_file, actual_offset, sizeof(struct note_command));
    if (is_swap) {
        swap_note_command(Nt, 0);
    }
    const char *cmd_name = "LC_NOTE";
    
    if (Nt->cmdsize != sizeof(struct note_command)) {
        printf(" Incorrect size\n");
    } else {
        const char *d = Nt->data_owner;
        printf("LC: %d %s data_owner: %.16s\n", ncmds, cmd_name, d);
    }
    free(Nt);
}

static void dump_linkedit_data_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct linkedit_data_command *ld = load_bytes(obj_file, actual_offset, sizeof(struct linkedit_data_command));
    if (is_swap) {
        swap_linkedit_data_command(ld, 0);
    }
    const char *cmd_name ;
    if (ld->cmd == LC_CODE_SIGNATURE) {
        cmd_name = "LC_CODE_SIGNATURE";
    } else if (ld->cmd == LC_SEGMENT_SPLIT_INFO) {
        cmd_name = "LC_SEGMENT_SPLIT_INFO";
    } else if (ld->cmd == LC_FUNCTION_STARTS) {
        cmd_name = "LC_FUNCTION_STARTS";
    } else if (ld->cmd == LC_DATA_IN_CODE) {
        cmd_name = "LC_DATA_IN_CODE";
    } else if (ld->cmd == LC_DYLIB_CODE_SIGN_DRS) {
        cmd_name = "LC_DYLIB_CODE_SIGN_DRS";
    } else if (ld->cmd == LC_DYLIB_CODE_SIGN_DRS) {
        cmd_name = "LC_DYLIB_CODE_SIGN_DRS";
    } else if (ld->cmd == LC_LINKER_OPTIMIZATION_HINT) {
        cmd_name = "LC_LINKER_OPTIMIZATION_HINT";
    }
    if (ld->cmdsize != sizeof(struct linkedit_data_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s cmdsize: %u dataoff: %u datasize: %u \n", ncmds, cmd_name, ld->cmdsize, ld->dataoff, ld->datasize);
        uint64_t big_size = ld->dataoff;
        big_size += ld->datasize;
    }
    free(ld);
}

static void dump_build_version_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct build_version_command *bd = load_bytes(obj_file, actual_offset, sizeof(struct build_version_command));
    if (is_swap) {
        swap_build_version_command(bd, 0);
    }
    const char *cmd_name = "LC_BUILD_VERSION";
    
    if (bd->cmdsize != sizeof(struct build_version_command) + bd->ntools * sizeof(struct build_tool_version)) {
        printf(" Incorrect size\n");
    } else {
        const char *platform = getBuildPlatform(bd->platform);
        char *sdk = getVersionString(bd->sdk);
        char *minos = getVersionString(bd->minos);
        printf("LC: %d %s platform: %s, sdk: %s, minos: %s, ntools: %u\n", ncmds, cmd_name, platform, sdk, minos, bd->ntools);
        
    }
    free(bd);
}

static void dump_rpath_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct rpath_command *rpath = load_bytes(obj_file, actual_offset, sizeof(struct rpath_command));
    if (is_swap) {
        swap_rpath_command(rpath, 0);
    }
    const char *cmd_name = "LC_RPATH";
    
    if (rpath->cmdsize < sizeof(struct rpath_command)) {
        printf(" Incorrect size\n");
    } else {
        char *P = load_bytes(obj_file, actual_offset + rpath->path.offset, rpath->cmdsize - rpath->path.offset);
        
        if (rpath->path.offset >= rpath->cmdsize) {
            printf("LC: %d %s path ?(bad offset %s )\n", ncmds, cmd_name, P);
        }
        printf("LC: %d %s path: %s \n", ncmds, cmd_name, P);
        
        free(P);
    }
    free(rpath);
}

static void dump_source_version_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct source_version_command *sd = load_bytes(obj_file, actual_offset, sizeof(struct source_version_command));
    if (is_swap) {
        swap_source_version_command(sd, 0);
    }
    const char *cmd_name = "LC_SOURCE_VERSION";
    
    if (sd->cmdsize != sizeof(struct source_version_command)) {
        printf(" Incorrect size\n");
    } else {
        uint64_t a = (sd->version >> 40) & 0xffffff;
        uint64_t b = (sd->version >> 30) & 0x3ff;
        uint64_t c = (sd->version >> 20) & 0x3ff;
        uint64_t d = (sd->version >> 10) & 0x3ff;
        uint64_t e = sd->version & 0x3ff;
        
        printf("LC: %d %s version: %llu.%llu", ncmds, cmd_name, a, b);
        if (e != 0) {
            printf(".%llu.%llu.%llu",c, d, e);
        }
        else if (d != 0) {
            printf(".%llu.%llu",c, d);
        } else if (c != 0) {
            printf(".%llu",c);
        }
        printf("\n");
    }
    free(sd);
}


static void dump_entry_point_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct entry_point_command *ep = load_bytes(obj_file, actual_offset, sizeof(struct entry_point_command));
    if (is_swap) {
        swap_entry_point_command(ep, 0);
    }
    const char *cmd_name = "LC_MAIN";
    
    if (ep->cmdsize != sizeof(struct entry_point_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s entryoff: %llu stacksize: %llu\n", ncmds, cmd_name, ep->entryoff, ep->stacksize);
    }
    free(ep);
}
static void dump_encryption_info_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct encryption_info_command *ec = load_bytes(obj_file, actual_offset, sizeof(struct encryption_info_command));
    if (is_swap) {
        swap_encryption_command(ec, 0);
    }
    const char *cmd_name = "LC_ENCRYPTION_INFO";
    
    if (ec->cmdsize != sizeof(struct encryption_info_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s cryptoff: %u cryptsize: %u cryptid: %u", ncmds, cmd_name, ec->cryptoff, ec->cryptsize, ec->cryptid);
    }
    free(ec);
}

static void dump_encryption_info_64_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct encryption_info_command_64 *ec = load_bytes(obj_file, actual_offset, sizeof(struct encryption_info_command_64));
    if (is_swap) {
        swap_encryption_command_64(ec, 0);
    }
    const char *cmd_name = "LC_ENCRYPTION_INFO_64";
    
    if (ec->cmdsize != sizeof(struct encryption_info_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s cryptoff: %u cryptsize: %u cryptid: %u", ncmds, cmd_name, ec->cryptoff, ec->cryptsize, ec->cryptid);
    }
    free(ec);
}
static void dump_linker_option_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct linker_option_command *lo = load_bytes(obj_file, actual_offset, sizeof(struct linker_option_command));
    if (is_swap) {
        swap_linker_option_command(lo, 0);
    }
    const char *cmd_name = "LC_LINKER_OPTION";
    
    if (lo->cmdsize != sizeof(struct linker_option_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s count: %u", ncmds, cmd_name, lo->count);
        char *string = load_bytes(obj_file, actual_offset + sizeof(struct linker_option_command), sizeof(struct linker_option_command));
        
        uint32_t left = lo->cmdsize - sizeof(struct linker_option_command);
        uint32_t i = 0;
        while (left > 0) {
            while (*string == '\0' && left > 0) {
                string++;
                left--;
            }
            if (left > 0) {
                i++;
                char dest[left];
                strncpy(dest, string, left);
                printf("string #%d %.*s", i, left, string);
                size_t NullPos = strlen(strchr(dest, '\0'));
                
                unsigned long len = (NullPos > left ? left : NullPos) + 1;
                string += len;
                left -= len;
            }
        }
        if (lo->count != i) {
            printf("  count %u oes not match number of strings", lo->count);
        }
        printf("\n");
    }
    free(lo);
}

static void dump_sub_framework_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct sub_framework_command *sub = load_bytes(obj_file, actual_offset, sizeof(struct sub_framework_command));
    if (is_swap) {
        swap_sub_framework_command(sub, 0);
    }
    const char *cmd_name = "LC_SUB_FRAMEWORK";
    
    if (sub->cmdsize != sizeof(struct sub_framework_command)) {
        printf(" Incorrect size\n");
    } else {
        if (sub->umbrella.offset < sub->cmdsize) {
            char *P = load_bytes(obj_file, actual_offset + sub->umbrella.offset, sub->cmdsize - sub->umbrella.offset);
            
            printf("LC: %d %s umbrella: %s", ncmds, cmd_name, P);
        } else {
            printf("LC: %d %s umbrella ?(bad offset %u )", ncmds, cmd_name, sub->umbrella.offset);
            
        }
    }
    free(sub);
}

static void dump_sub_umbrella_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct sub_umbrella_command *sub = load_bytes(obj_file, actual_offset, sizeof(struct sub_umbrella_command));
    if (is_swap) {
        swap_sub_umbrella_command(sub, 0);
    }
    const char *cmd_name = "LC_SUB_UMBRELLA";
    
    if (sub->cmdsize != sizeof(struct sub_umbrella_command)) {
        printf(" Incorrect size\n");
    } else {
        if (sub->sub_umbrella.offset < sub->cmdsize) {
            char *P = load_bytes(obj_file, actual_offset + sub->sub_umbrella.offset, sub->cmdsize - sub->sub_umbrella.offset);
            
            printf("LC: %d %s sub_umbrella: %s\n", ncmds, cmd_name, P);
        } else {
            printf("LC: %d %s sub_umbrella ?(bad offset %u )\n", ncmds, cmd_name, sub->sub_umbrella.offset);
            
        }
    }
    free(sub);
}

static void dump_sub_library_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct sub_library_command *sub = load_bytes(obj_file, actual_offset, sizeof(struct sub_library_command));
    if (is_swap) {
        swap_sub_library_command(sub, 0);
    }
    const char *cmd_name = "LC_SUB_LIBRARY";
    
    if (sub->cmdsize != sizeof(struct sub_library_command)) {
        printf(" Incorrect size\n");
    } else {
        if (sub->sub_library.offset < sub->cmdsize) {
            char *P = load_bytes(obj_file, actual_offset + sub->sub_library.offset, sub->cmdsize - sub->sub_library.offset);
            
            printf("LC: %d %s sub_library: %s\n", ncmds, cmd_name, P);
        } else {
            printf("LC: %d %s sub_library ?(bad offset %u )\n", ncmds, cmd_name, sub->sub_library.offset);
            
        }
    }
    free(sub);
}
static void dump_sub_client_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct sub_client_command *sub = load_bytes(obj_file, actual_offset, sizeof(struct sub_client_command));
    if (is_swap) {
        swap_sub_client_command(sub, 0);
    }
    const char *cmd_name = "LC_SUB_CLIENT";
    
    if (sub->cmdsize != sizeof(struct sub_client_command)) {
        printf(" Incorrect size\n");
    } else {
        if (sub->client.offset < sub->cmdsize) {
            char *P = load_bytes(obj_file, actual_offset + sub->client.offset, sub->cmdsize - sub->client.offset);
            
            printf("LC: %d %s client: %s\n", ncmds, cmd_name, P);
        } else {
            printf("LC: %d %s client ?(bad offset %u )\n", ncmds, cmd_name, sub->client.offset);
        }
    }
    free(sub);
}
static void dump_routines_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct routines_command *r = load_bytes(obj_file, actual_offset, sizeof(struct routines_command));
    if (is_swap) {
        swap_routines_command(r, 0);
    }
    const char *cmd_name = "LC_ROUTINES";
    
    if (r->cmdsize != sizeof(struct routines_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s init_module: %u\n", ncmds, cmd_name, r->init_module);
    }
    free(r);
}

static void dump_routines_64_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct routines_command_64 *r = load_bytes(obj_file, actual_offset, sizeof(struct routines_command_64));
    if (is_swap) {
        swap_routines_command_64(r, 0);
    }
    const char *cmd_name = "LC_ROUTINES";
    
    if (r->cmdsize != sizeof(struct routines_command_64)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s init_module: %llu\n", ncmds, cmd_name, r->init_module);
    }
    free(r);
}

static void dump_uuid_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct uuid_command *uuid = load_bytes(obj_file, actual_offset, sizeof(struct uuid_command));
    if (is_swap) {
        swap_uuid_command(uuid, 0);
    }
    const char *cmd_name = "LC_UUID";
    
    if (uuid->cmdsize != sizeof(struct uuid_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s uuid ", ncmds, cmd_name);
        for (int i = 0; i < 16; ++i) {
            printf("%02X", uuid->uuid[i]);
            if (i == 3 || i == 5 || i == 7 || i == 9)
                printf("-");
        }
        printf("\n");
    }
    free(uuid);
}
static void dump_dysymtab_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct dysymtab_command *dyst = load_bytes(obj_file, actual_offset, sizeof(struct dysymtab_command));
    if (is_swap) {
        swap_dysymtab_command(dyst, 0);
    }
    const char *cmd_name = "LC_DYSYMTAB";
    
    if (dyst->cmdsize != sizeof(struct dysymtab_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s indirectsymoff: %d\n", ncmds, cmd_name, dyst->indirectsymoff);
    }
    free(dyst);
}
static void dump_symtab_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct symtab_command *st = load_bytes(obj_file, actual_offset, sizeof(struct symtab_command));
    if (is_swap) {
        swap_symtab_command(st, 0);
    }
    const char *cmd_name = "LC_SYMTAB";
    
    if (st->cmdsize != sizeof(struct symtab_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s symoff: %d nsyms: %d stroff: %d strsize: %d\n", ncmds, cmd_name, st->symoff, st->nsyms, st->stroff,st->strsize);
    }
    free(st);
}
static void dump_dyld_info_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct dyld_info_command *dc = load_bytes(obj_file, actual_offset, sizeof(struct dyld_info_command));
    if (is_swap) {
        swap_dyld_info_command(dc, 0);
    }
    const char *cmd_name;
    if (dc->cmd == LC_DYLD_INFO) {
        cmd_name = "LC_DYLD_INFO";
    } else {
        cmd_name = "LC_DYLD_INFO_ONLY";
    }
    
    if (dc->cmdsize != sizeof(struct dyld_info_command)) {
        printf(" Incorrect size\n");
    } else {
        printf("LC: %d %s rebase_off: %d rebase_size: %d bind_off: %d bind_size: %d weak_bind_off: %d weak_bind_size: %d lazy_bind_off: %d lazy_bind_size: %d export_off: %d export_size: %d\n", ncmds, cmd_name, dc->rebase_off, dc->rebase_size, dc->bind_off, dc->bind_size, dc->weak_bind_off, dc->weak_bind_size, dc->lazy_bind_off, dc->lazy_bind_size, dc->export_off, dc->export_size);
    }
    free(dc);
}

static void dump_segment_64_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    struct segment_command_64 *segment = load_bytes(obj_file, actual_offset, sizeof(struct segment_command_64));
    if (is_swap) {
        swap_segment_command_64(segment, 0);
    }
    
    printf("LC: %d segname: %s vmaddr: %llx nsects: %x filesize: %llu vmsize: %llu\n", ncmds, segment->segname, segment->vmaddr, segment->nsects, segment->filesize, segment->vmsize);
    
    free(segment);
}

static void dump_segment_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;

    struct segment_command_64 *segment = load_bytes(obj_file, actual_offset, sizeof(struct segment_command_64));
    if (is_swap) {
        swap_segment_command_64(segment, 0);
    }
    
    printf("LC: %d segname: %s vmaddr: %llx nsects: %x filesize: %llu vmsize: %llu\n", ncmds, segment->segname, segment->vmaddr, segment->nsects, segment->filesize, segment->vmsize);
    
    free(segment);
}
static void dump_linker_option_command(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;

    struct linker_option_command *lo = load_bytes(obj_file, actual_offset, sizeof(struct linker_option_command));
    if (is_swap) {
        swap_linker_option_command(lo, 0);
    }
    const char *cmd_name = "LC_LINKER_OPTION";
    
    if (lo->cmdsize < sizeof(struct linker_option_command)) {
        printf(" Incorrect size\n");
    } else {
        uint32_t left = lo->cmdsize - sizeof(struct linker_option_command);

        const char *string = load_bytes(obj_file, actual_offset + sizeof(struct linker_option_command), left);
        uint32_t i = 0;
        printf("LC: %d %s", ncmds, cmd_name);
        while (left > 0) {
          while (*string == '\0' && left > 0) {
            string++;
            left--;
          }
          if (left > 0) {
            i++;
              
            printf(" string #%d %s ", i, string);
              char dest[left];
              strncpy(dest, string, left);
              size_t l = strlen(dest);
              size_t NullPos = dest[l+1] == '\0' ? l  : 0;
              unsigned long len = (NullPos > left ? left : NullPos) + 1;
            string += len;
            left -= len;
          }
        }
        if (lo->count != i) {
            printf("   count %d does not match number of strings ", lo->count);
        }
        printf("\n");
    }
    free(lo);
}

static void dump_load_commands(FILE *obj_file, off_t offset, bool is_swap, uint32_t ncmds) {
    off_t actual_offset = offset;
    for (uint32_t i = 0U; i < ncmds; i++) {
        struct load_command *cmd = load_bytes(obj_file, actual_offset, sizeof(struct load_command));
        if (is_swap) {
            swap_load_command(cmd, 0);
        }
        
        if (cmd->cmd == LC_SEGMENT_64) {
            dump_segment_64_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SEGMENT) {
            dump_segment_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LINKER_OPTION) {
            dump_linker_option_command(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ID_DYLIB) {
            dump_dylib_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LOAD_DYLIB) {
            dump_dylib_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LOAD_WEAK_DYLIB) {
            dump_dylib_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LAZY_LOAD_DYLIB) {
            dump_dylib_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_REEXPORT_DYLIB) {
            dump_dylib_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LOAD_UPWARD_DYLIB) {
            dump_dylib_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ID_DYLINKER) {
            dump_dyld_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_DYLD_INFO) {
            dump_dyld_info_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_DYLD_INFO_ONLY) {
            dump_dyld_info_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LOAD_DYLINKER) {
            dump_dyld_load_commands(obj_file, actual_offset, is_swap, i);
            
        } else if (cmd->cmd == LC_DYLD_ENVIRONMENT) {
            dump_dyld_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_VERSION_MIN_MACOSX) {
            dump_version_min_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_VERSION_MIN_IPHONEOS) {
            dump_version_min_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_VERSION_MIN_TVOS) {
            dump_version_min_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_VERSION_MIN_WATCHOS) {
            dump_version_min_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_UUID) {
            dump_uuid_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_NOTE) {
            dump_note_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_BUILD_VERSION) {
            dump_build_version_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_RPATH) {
            dump_rpath_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SYMTAB) {
            dump_symtab_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_DYSYMTAB) {
            dump_dysymtab_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SOURCE_VERSION) {
            dump_source_version_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_MAIN) {
            dump_entry_point_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ENCRYPTION_INFO) {
            dump_encryption_info_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ENCRYPTION_INFO_64) {
            dump_encryption_info_64_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LINKER_OPTION) {
            dump_linker_option_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SUB_FRAMEWORK) {
            dump_sub_framework_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SUB_UMBRELLA) {
            dump_sub_umbrella_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SUB_LIBRARY) {
            dump_sub_library_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SUB_CLIENT) {
            dump_sub_client_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ROUTINES) {
            dump_routines_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ROUTINES_64) {
            dump_routines_64_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_CODE_SIGNATURE) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_SEGMENT_SPLIT_INFO) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_FUNCTION_STARTS) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_DATA_IN_CODE) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_ROUTINES_64) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_DYLIB_CODE_SIGN_DRS) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        } else if (cmd->cmd == LC_LINKER_OPTIMIZATION_HINT) {
            dump_linkedit_data_load_commands(obj_file, actual_offset, is_swap, i);
        }
        
        actual_offset += cmd->cmdsize;
        
        free(cmd);
    }
}

static void dump_mach_header(FILE *obj_file, off_t offset, bool is_64, bool is_swap) {
    uint32_t ncmds;
    off_t load_commands_offset = offset;
    
    if (is_64) {
        size_t header_size = sizeof(struct mach_header_64);
        struct mach_header_64 *header = load_bytes(obj_file, offset, header_size);
        if (is_swap) {
            swap_mach_header_64(header, 0);
        }
        ncmds = header->ncmds;
        load_commands_offset += header_size;
        
        printf("%s\n", cpu_type_name(header->cputype));
        
        free(header);
    } else {
        size_t header_size = sizeof(struct mach_header);
        struct mach_header *header = load_bytes(obj_file, offset, header_size);
        if (is_swap) {
            swap_mach_header(header, 0);
        }
        
        ncmds = header->ncmds;
        load_commands_offset += header_size;
        
        printf("%s\n", cpu_type_name(header->cputype));
        
        free(header);
    }
    
    dump_load_commands(obj_file, load_commands_offset, is_swap, ncmds);
}

static void dump_fat_header(FILE *obj_file, int is_swap) {
    size_t header_size = sizeof(struct fat_header);
    size_t arch_size = sizeof(struct fat_arch);
    
    struct fat_header *header = load_bytes(obj_file, 0, header_size);
    if (is_swap) {
        swap_fat_header(header, 0);
    }
    
    off_t arch_offset = (off_t)header_size;
    for (uint32_t i = 0U; i < header->nfat_arch; i++) {
        struct fat_arch *arch = load_bytes(obj_file, arch_offset, arch_size);
        
        if (is_swap) {
            swap_fat_arch(arch, 1, 0);
        }
        
        off_t mach_header_offset = (off_t)arch->offset;
        free(arch);
        arch_offset += arch_size;
        
        uint32_t magic = read_magic(obj_file, mach_header_offset);
        int is_64 = is_magic_64(magic);
        int is_swap_mach = should_swap_bytes(magic);
        dump_mach_header(obj_file, mach_header_offset, is_64, is_swap_mach);
    }
    free(header);
}

void dump_segments(FILE *obj_file) {
    uint32_t magic = read_magic(obj_file, 0);
    int is_64 = is_magic_64(magic);
    int is_swap = should_swap_bytes(magic);
    int fat = is_fat(magic);
    if (fat) {
        dump_fat_header(obj_file, is_swap);
    } else {
        dump_mach_header(obj_file, 0, is_64, is_swap);
    }
}
