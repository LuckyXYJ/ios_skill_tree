## 多环境配置

多**target**，多**Configuration**

target：一个project中可以创建多个target，可以用来做分包、马甲包。

Configuration：在scheme中配置使用不同的Configuration，常用来做环境区分

### target

缺点：

1. 生成多个info.plist文件
2. 配置繁琐且乱，容易配置遗忘其它targets
3. 通过声明宏的方式，容易写错
4. 真机测试需要的描述文件等比较多

优点：

1. 包名可以不同，方便做分包，马甲包需求。
2. 一个target代表一个应用，可以实现更多区分配置

### Configuration

区分不同环境方式，可以在代码中区分。也可以通过在buildsetting中设置自定义参数

优点：

1. 在 Building Settings 里所有的参数都对应不同的config，这就意味着可以设置不一样的Icons、图标、名称等等...
2. 配置不同的scheme即可使用不同的配置，方便进行自动打包

缺点：

1. 多个config配置，操作繁琐，可以用xcconfg文件对其进行优化

## xcconfig文件

使用xcconfig可以通过管理文件的方式，管理不同的配置

### 使用xcconfig常见问题

1、xcconfig与cocoapods冲突

通过`Cocoapods`导入第三方库 `$ pod install` 后，我们的工程会自动配置成默认生效是使用了`Pods-ProjectName.Debug.xcconfig`的xcconfig，那我们自定义的xcconfig就没法生效了。

解决方案：

在自定义的xcconfig中导入Pods-ProjectName.Debug.xcconfig

xcconfig生效的地方设置成我们自定义的xcconfig文件即可。

```
#include "Pods/Target Support Files/Pods-LoginApp/Pods-LoginApp.debug.xcconfig"
```

2、配置url时`//`无法配置问题

在xcconfig文件中，双斜线为默认为注释

解决方案：

可以定义 A=/,双斜线换成{A}/

3、配置冲突

自定义config文件中设置` OTHER_LDFLAGS`与cocoapods生成文件中的OTHER_LDFLAGS冲突时，只有一个生效

解决方案：在配置前面加上` $(inherited)`

```
OTHER_LDFLAGS = $(inherited) -framework "AFNetworking"
```

### 优先级（由高到低）

1. 手动配置Target Build Setting
2. Target中配置的xcconfig文件
3. 手动配置Project Build Setting
4. Project中配置的xcconfig文件

## xcode常见宏

TARGET_NAME：目标工程名称

SRCROOT：当前代码路径，工程文件（比如Nuno.xcodeproj）的路径

BUILD_DIR：当前编译的路径

BUILT_PRODUCTS_DIR：最终产品路径，build成功后的，最终产品路径－－可以在Build Settings参数的Per-configuration Build Products Path项里设置

CURRENT_PROJECT_VERSION：当前工程版本号

PRODUCT_NAME：产品名字

CONFIGURATION：表示当前状态是调试Debug还是运行状态release

EFFECTIVE_PLATFORM_NAME：宏代表当前配置是OS还是simulator

PLATFORM_NAME = iphonesimulator 表示获取当前程序运行的平台

SDK_NAME

$(EXECUTABLE_NAME) = libUtilLib.a，表示可执行文件libUtiLib.a



