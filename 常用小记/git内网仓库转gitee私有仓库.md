## git内网仓库转gitee私有仓库

```shell
#!/bin/bash

# 分支名
BRANCH="branch"

# 文件夹
DIR=dir

# 原remote url
ORIGINURL=git@xxxxxxxxxxxx:xxxxx/branch.git

# gitee remote url
GITEEURL=git@xxxxxxxxxxxx:xxxxx/branch.git

# 原 remote name
ORIGIN=origin

# gitee remote name
GITEE=gitee

# 通过参数设置branch
if [ "$#" -gt 0 ]; then
    echo $1
    BRANCH=$1
else
    echo 无参数
fi

rm -rf ${DIR}

git clone ${ORIGINURL} ${DIR}

cd ${DIR}

git checkout -B ${BRANCH}

git pull ${ORIGIN} ${BRANCH}

git remote remove ${ORIGIN}

git remote add ${GITEE} ${GITEEURL}

git push ${GITEE} ${BRANCH}:${BRANCH}
```

