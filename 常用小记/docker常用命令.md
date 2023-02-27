## 查看镜像

```
docker images
```

## 删除镜像

```
docker rmi [镜像id]
```

## 镜像更新

```
docker pull whyour/qinglong
```

更新镜像要用镜像REPOSITORY。相当于下载新的镜像。下载后可以把旧的删除

## 查看容器

```
docker ps //查看开启的容器

docker ps -a // 查看所有的容器

-a :显示所有的容器，包括未运行的。
-f :根据条件过滤显示的内容。
--format :指定返回值的模板文件。
-l :显示最近创建的容器。
-n :列出最近创建的n个容器。
--no-trunc :不截断输出。
-q :静默模式，只显示容器编号。
-s :显示总的文件大小。
```

## 删除容器

```
docker rm [容器名/容器id]
```

## 关闭容器

```
docker stop [容器id]
docker-compose down
```

## 容器路径

```
docker inspect [容器的id] //找出你容器的映射到本地的文件路径
```

## 启动容器

```
docker-compose up -d --remove-orphans #重启

docker-compose up -d // 启动

docker-compose up // 启动，但是不能退出命令行
```

## docker使用情况

```
# Docker整体磁盘使用率的概况，包括镜像、容器和（本地）volume。
docker system df
```

## docker 清理

```
[root@localhost ~]# docker system prune
WARNING! This will remove:
        - all stopped containers # 清理停止的容器
        - all networks not used by at least one container #清理没有使用的网络
        - all dangling images #清理废弃的镜像
        - all build cache #清理构建缓存
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
```

## 进入容器命令

```
// 命令
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
```

OPTIONS说明：
-d :分离模式: 在后台运行
-i :即使没有附加也保持STDIN 打开
-t :分配一个伪终端

```
docker exec -it 68711931de2e /bin/sh
```