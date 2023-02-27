
@interface FBBundleInfo : NSObject {
    NSString * _bundleIdentifier;
    NSString * _bundleType;
    NSURL * _bundleURL;
    NSString * _bundleVersion;
    NSUUID * _cacheGUID;
    NSDictionary * _extendedInfo;
    unsigned int  _sequenceNumber;
}

@property (nonatomic, readonly, copy) NSString *bundleIdentifier;
@property (nonatomic, readonly, copy) NSString *bundleType;
@property (nonatomic, readonly, retain) NSURL *bundleURL;
@property (nonatomic, readonly, copy) NSString *bundleVersion;
@property (nonatomic, readonly, copy) NSUUID *cacheGUID;
@property (nonatomic, readonly) unsigned int sequenceNumber;

- (id)_initWithBundleIdentifier:(id)arg1 url:(id)arg2;
- (id)_initWithBundleProxy:(id)arg1 bundleIdentifier:(id)arg2 url:(id)arg3;
- (id)_initWithBundleProxy:(id)arg1 overrideURL:(id)arg2;
- (id)bundleIdentifier;
- (id)bundleType;
- (id)bundleURL;
- (id)bundleVersion;
- (id)cacheGUID;
- (void)dealloc;
- (id)extendedInfo;
- (id)extendedInfoValueForKey:(id)arg1;
- (id)init;
- (unsigned int)sequenceNumber;
- (void)setExtendedInfo:(id)arg1;

@end
