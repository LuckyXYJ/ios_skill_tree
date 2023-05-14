## git 配置 config

Git 自带一个 git config 的工具来帮助设置控制 Git 外观和行为的配置变量。 这些变量存储在三个不同的位置：

1. /etc/gitconfig 文件: 包含系统上每一个用户及他们仓库的通用配置。 如果在执行 git config 时带上 --system 选项，那么它就会读写该文件中的配置变量。 （由于它是系统配置文件，因此你需要管理员或超级用户权限来修改它。）
2. ~/.gitconfig 或 ~/.config/git/config 文件：只针对当前用户。 你可以传递 --global 选项让 Git 读写此文件，这会对你系统上所有的仓库生效。
3. 当前使用仓库的 Git 目录中的 config 文件（即 .git/config）：针对该仓库。 你可以传递 --local 选项让 Git 强制读写此文件，虽然默认情况下用的就是它。 

| 配置级别 | 配置文件       | 英文描述 | 优先级     |
| -------- | -------------- | -------- | ---------- |
| 仓库级别 | /etc/gitconfig | local    | 优先级最高 |
| 用户级别 | ~/.gitconfig   | global   | 优先级次之 |
| 系统级别 | .git/config    | system   | 优先级最低 |

### 增加配置

``` git config [--local|--global|--system] --add section.key value ```

### 获取配置

` git config [--local|--global|--system] --get section.key`

### 删除配置

` git config [--local|--global|--system] --unset section.key`

### 查看配置详解

| 命令                   | 描述                                                   |
| ---------------------- | ------------------------------------------------------ |
| git config --local -l  | 查看仓库配置                                           |
| git config --global -l | 查看用户配置                                           |
| git config --system -l | 查看系统配置                                           |
| git config -l          | 查看所有的配置信息，依次是系统级别、用户级别、仓库级别 |

### 编辑配置

| 命令                   | 描述                 |
| ---------------------- | -------------------- |
| git config --local -e  | 编辑仓库级别配置文件 |
| git config --global -e | 编辑用户级别配置文件 |
| git config --system -e | 编辑系统级别配置文件 |

### 添加配置

| 命令                                     | 描述            |
| ---------------------------------------- | --------------- |
| git config --global user.email “eamil”   | 添加 email 配置 |
| git config --global user.name “username” | 添加用户名配置  |

```shell
git config --global user.name '*' # 设置username

git config --global user.email '*@qq.com' # 设置email

git config --list

# 查看所有的配置以及它们所在的文件：
git config --list --show-origin
```

### git设置命令别名详解

```
git config --global alias.aliasCmd cmd
```

| 参数     | 描述       |
| -------- | ---------- |
| aliasCmd | 命令别名。 |
| cmd      | 命令。     |

## git 基础

### 创建仓库

```shell
git init # 创建一个空仓库
git init --bare # 创建一个裸仓库
```

### 克隆仓库

```shell
git clone url [dir] # clone仓库
```

### 追踪新文件

```shell
git add [options] files
```

| 实例 | 描述 |
| ---- | ---- |
| git add file | 仅追踪 file 文件。    |
| git add .    | 他会监控工作区的状态树，使用它会把工作时的所有变化提交到暂存区，包括文件内容修改(modified)以及新文件(new)，但不包括被删除的文件。 |
| git add -u   | 他仅监控已经被 add 的文件（即 tracked file），他会将被修改的文件提交到暂存区。add -u 不会提交新文件（untracked file）。 |
| git add -A   | 提交所有变化。                                               |

### 提交文件

```shell
git commit [options]
```

| 实例                       | 描述                                                         |
| -------------------------- | ------------------------------------------------------------ |
| git commit -m “message”    | 提交到版本库，并指定提交信息。                               |
| git commit -a -m “message” | -a 参数表示，可以将所有已跟踪文件中的执行修改或删除操作的文件都提交到本地仓库，即使它们没有经过 **git add** 添加到暂存区。 |
| git commit --amend         | 追加提交，它可以在不增加一个新的 commit-id 的情况下将新修改的代码追加到前一次的 commit-id 中。 |

### 查看文件状态

```
git status [options]
```

| 实例                 | 描述                         |
| -------------------- | ---------------------------- |
| git status           | 显示工作目录和暂存区的状态。 |
| git status -s        | 以精简的方式显示文件状态。   |
| git status --ignored | 列出被忽略的文件。           |

### 移除文件

```shell
git rm [options] files

git rm file # 同时从工作区和索引中删除文件，即本地的文件也被删除了。
git rm --cached file # 从索引中删除文件，但是本地文件还存在， 只是不希望这个文件被版本控制。
```

### 重命名文件

```
git mv [options] files
```

| 参数        | 描述                                       |
| ----------- | ------------------------------------------ |
| –f, --force | 强制重命名。                               |
| -n          | 显示重命名会发生的改变，不进行重命名操作。 |

git mv 命令，相当于执行了以下三个命令：

```
mv README.md README $ git rm README.md $ git add README
```

在大小写不敏感的系统中，如 windows 中，重命名文件的大小写，使用临时文件名实现。

### 文件比较

```shell
git diff [options]
```

| 参数    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| –cached | 显示暂存区(已 add 但未 commit 文件)和最后一次 commit (HEAD)之间差异。 |
| –staged | 同 --cached。                                                |
| –stat   | 查看简单的 diff 比较结果。                                   |

示例

```shell
#查看尚未暂存的文件更新了哪些部分，此命令比较的是工作目录(Working tree)和暂存区域快照(index)之间的差异。 也就是修改之后还没有暂存起来的变化内容。
git diff 

# 查看已经暂存起来的文件(staged)和上次提交时的快照之间(HEAD)的差异。 显示的是下一次 commit 时会提交到 HEAD 的内容(不带 -a 情况下)。
git diff --cached

# 显示工作版本(Working tree)和 HEAD 的差别。
git diff HEAD

# 查看尚未暂存的某个文件的更新
git diff filename

# 查看已经暂存起来的某个文件和上次提交的版本之间的差异。
git diff –cached filename

# 查看版本 sha1 的文件 filename 和版本 sha2 的文件 filename 的差异。
git diff sha1:filename sha2:filename

# 直接将两个分支上最新的提交做比较。
git diff topic master

# 输出自 topic 和 master 分别开发以来，master 分支上的 changed。
git diff topic…master

# 查看简单的 diff 结果，可以加上 --stat 参数。
git diff --stat

# 显示当前目录和另一个叫 ‘test’ 分支的差别。
git diff test

# 显示当前目录下的 lib 目录和上次提交之间的差别。
git diff HEAD – ./lib

# 比较上次提交 commit 和上上次提交。
git diff HEAD^ HEAD

# 比较两个历史版本之间的差异。
git diff SHA1 SHA2
```

### 放弃文件修改

```
git checkout -- file
```

```shell
git checkout . # 放弃工作区所有文件的修改。
git checkout -- file # 放弃工作区指定文件的修改
```

### 撤销操作

```
git reset [options] [file]
```

git reset 命令是用来将当前 branch 重置到另外一个 commit 的，这个动作可能同时影响到 index 以及 work directory。

```shell
git reset --soft # 保留 working Tree 工作目录和 index 暂存区的内容，只让 repository 中的内容和 reset 目标节点保持一致。
git reset --mixed # ，只保留 Working Tree 工作目录的內容，但会将 Index 暂存区 和 Repository 中的內容更改和 reset 目标节点一致
git reset --hard # 清空暂存区和工作区。要放弃目前本地的所有改变时.抛弃目标节点后的所有 commit
```

## git回滚操作

### 修改完还未git add

```
git checkout . # 使用暂存区的文件覆盖工作区
```

### git add提交还未commit

使用 git add 提交到暂存区，还未 commit 之前，使用 git reset 和 git checkout 回滚：

```
git reset  # 先用 Head 指针覆盖当前的暂存区内容
git checkout . # 再用暂存区内容覆盖工作区内容
```

或者使用：

```
git reset --hard
```

直接使用 head 覆盖当前暂存区和工作区。

### 已经git commit还未git push

已经执行了 git commit，但还没有执行 git push，使用 git reset 回滚：

```
git reset --hard last_commit_id
```

覆盖本地仓库、暂存区和工作区。

### 已经git push

修改错了，完全覆盖掉，使用：

```
git reset --hard commit_id
```

错误的把文件添加到了缓存区，使用：

```
git reset
```

撤回添加。

## git 远程仓库 remote

### 将代码添加到远程 git 仓库。

```
git remote add [shortname] [url]
```

### 远程仓库下载

```
git clone url
```

### 查看远程仓库详解

```
git remote [options]
```

```
git remote //查看源
git remote -v //查看远程源仓库地址
git remote show origin // 查看远程仓库信息，origin仓库名
git remote add [shortname] [url] // 添加源名字，源地址
```

### git删除远程仓库详解

```
git remote rm origin # 删除源
```

### git重命名远程仓库详解

```
git remote rename old new # git重命名远程仓库详解
```

### git修改远程仓库地址详解

```
git remote set-url origin url
```

### Git拉取远程仓库(git fetch)

```
git fetch [options]
```

| 实例                 | 描述                                                |
| -------------------- | --------------------------------------------------- |
| git fetch            | 创建并更新本地远程分支。                            |
| git fetch origin     | 将 origin 远程主机的更新，全部取回本地。            |
| git fetch origin dev | 将 origin 远程主机的 dev 分支的更新，全部取回本地。 |

git pull 等于：

```
git pull = git fetch + git merge
```

取回远程主机分支的更新，并与本地合并。

```
git pull [options] [remote]
```

| 实例                        | 描述                                                         |
| --------------------------- | ------------------------------------------------------------ |
| git pull                    | 当前分支自动与唯一一个追踪分支进行合并。                     |
| git pull origin             | 本地的当前分支自动与对应的 origin 主机 “追踪分支” 进行合并。 |
| git pull origin next        | 取回 origin/next 分支，再与当前分支合并。                    |
| git pull origin next:master | 取回 origin 主机的 next 分支，与本地的 master 分支合并。     |

## git push命令详解

用于将本地分支的更新，推动到远程。

```
git push <远程主机名> <本地分支名>:<远程分支名>
```

| 实例                          | 描述                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| git push                      | 如果当前分支只有一个追踪分支，那么主机名都可以省略，表示将当前分支推送到 origin 主机的对应分支。 |
| git push origin               | 将当前分支推送到 origin 主机的对应分支。                     |
| git push origin master        | 将本地的 master 分支推送到 origin 主机的 master 分支。如果后者不存在，则会被新建。 |
| git push origin master:newdev | 将本地的 master 分支推送到 origin 主机的 newdev 分支。如果后者不存在，则会被新建。 |
| git push origin :master       | 删除远程仓库的分支。                                         |
| git push -u origin master     | 如果当前分支与多个主机存在追踪关系，则可以使用 -u 参数指定一个默认主机，这样后面就可以不加任何参数使用 git push。 |
| git push --all origin         | 不管是否存在对应的远程分支，将本地的所有分支都推送到远程主机。 |
| git push origin --tags        | 把 tag 推送到远端仓库。                                      |

## git标签

### git创建标签(git tag)详解

```
git tag tagName [commitId]
```

### 指定标签的备注信息

```
git tag -a tagName -m"tagnote"
```

### git查看所有标签详解

```
git tag -l
```

### git查看标签详解

```
git show tagName
```

### git删除本地标签详解

```
git tag -d tagName
```

### git删除远程标签详解

git push 命令可以删除远程的 tag 标签。tagName：需要删除的远程标签的标签名

```
git push origin :refs/tags/tagName
```

### git推送tag到远程详解

```
git push origin [tagname]
```

### git推送所有tag到远程详解

```
git push origin --tags
```

### 重命名tag标签详解

```
git tag newTag oldTag
git tag -d oldTag 
```

我们使用 git tag 将标签重命名后，我们还需要使用 git tag -d 命令，将旧标签删除，如果我们还需要将修改后的标签投送到远程，我们还需要使用如下命令：

```
git push origin：refs/tags/oldTag
git push --tags 
```

push 命令中的冒号将标记从远程存储库。如果你不这样做，git 会在你的机器上创建旧的标签。最后，确保其他用户删除已删除的标签。请告诉他们运行以下命令：

```
git pull --prune --tags 
```

