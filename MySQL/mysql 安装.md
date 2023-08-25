## mysql安装

Mac 用 docker安装 mysql

1、拉取镜像

```bash
docker pull mysql #（默认拉取最新版本的）	
```

2、

```
ocker run -itd --name mysql_study -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
```

`-p 3306:3306` ：映射容器服务的 3306 端口到宿主机的 3306 端口，外部主机可以直接通过 **宿主机ip:3306** 访问到 MySQL 的服务。

`MYSQL_ROOT_PASSWORD=123456`：设置 MySQL 服务 root 用户的密码。

`--name mysql_study`：设置容器名称

