## Package及Plugin创建

创建Dart包，使用参数 ` --WemplaWe=package`来执行 ` flutter create`

```
flutter create --template=package 'package_name'
```

创建插件，使用参数使用参数 ` --WemplaWe=plugin`来执行 ` flutter create`

```
flutter create --template=plugin 'plugin_name'
```

指定组织名称,使用` --org` 选项指定组织,包不需要指定组织名称，`--org`只在创建plugin时生效

```
flutter create --org com.example --template=plugin 'plugin_name'
```

指定iOS安卓语言，`-i`,`-a`

```
flutter create --template=plugin -i swift -a kotlin 'plugin_name'
```

## Package及Plugin创建发布

检查包

```
flutter packages pub publish --dry-run
```

发布，发布需要Google账号，使用Google进行授权。

```
flutter packages pub publish
```

如果因为镜像上传失败，可以指定服务器上传

```
flutter packages pub publish --server=https://pub.dartlang.org
```



