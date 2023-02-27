## 包管理工具npm

Node Package Manager，也就是Node包管理器

配置文件：package.json。

- 记录着你项目的名称、版本号、项目描述。
- 记录着你项目所依赖的其他库的信息和依赖库的版本号；

创建配置文件：

- 手动从零创建项目，npm init –y 
- 通过脚手架创建项目，脚手架会帮助我们生成package.json，并且里面有相关的配置

### 常见的属性

- 必须填写的属性：name、version 
  - name是项目的名称； 
  - version是当前项目的版本号； 
  - description是描述信息，很多时候是作为项目的基本描述； 
  - author是作者相关信息（发布时用到）； 
  - license是开源协议（发布时用到）；
- private属性：
  - private属性记录当前的项目是否是私有的； 
  - 当值为true时，npm是不能发布它的，这是防止私有项目或模块发布出去的方式；  
- main属性：
  - 设置程序的入口。 
  - 很多人会有疑惑，webpack不是会自动找到程序的入口吗？ 
    - 这个入口和webpack打包的入口并不冲突； 
    - 它是在你发布一个模块的时候会用到的； 
    - 比如我们使用axios模块 const axios = require('axios'); 
    - 实际上是找到对应的main属性查找文件的；
- scripts属性
  - scripts属性用于配置一些脚本命令，以键值对的形式存在； 
  - 配置后我们可以通过 npm run 命令的key来执行这个命令； 
  - npm start和npm run start的区别是什么？
    - 它们是等价的；
    - 对于常用的 start、 test、stop、restart可以省略掉run直接通过 npm start等方式运行；
- dependencies属性
  - dependencies属性是指定无论开发环境还是生成环境都需要依赖的包； 
  - 通常是我们项目实际开发用到的一些库模块vue、vuex、vue-router、react、react-dom、axios等等； 
  - 与之对应的是devDependencies；
- devDependencies属性
  - 一些包在生成环境是不需要的，比如webpack、babel等； 
  - 这个时候我们会通过 npm install webpack --save-dev，将它安装到devDependencies属性中；
- peerDependencies属性
  - 还有一种项目依赖关系是对等依赖，也就是你依赖的一个包，它必须是以另外一个宿主包为前提的； 
  - 比如element-plus是依赖于vue3的，ant design是依赖于react、react-dom；
- engines属性engines属性
  - 用于指定Node和NPM的版本号；
  - 在安装的过程中，会先检查对应的引擎版本，如果不符合就会报错； 
  - 事实上也可以指定所在的操作系统 "os" : [ "darwin", "linux" ]，只是很少用到；
- browserslist属性
  - 用于配置打包后的JavaScript浏览器的兼容情况，参考； 
  - 否则我们需要手动的添加polyfills来让支持某些语法； 
  - 也就是说它是为webpack等打包工具服务的一个属性（这里不是详细讲解webpack等工具的工作原理，所以不 再给出详情）；

### 依赖的版本管理

npm的包通常需要遵从semver版本规范：

semver版本规范是X.Y.Z： 

- X主版本号（major）：当你做了不兼容的 API 修改（可能不兼容之前的版本）； 
- Y次版本号（minor）：当你做了向下兼容的功能性新增（新功能增加，但是兼容之前的版本）； 
- Z修订号（patch）：当你做了向下兼容的问题修正（没有新功能，修复了之前版本的bug）；

^和~的区别：

- ^x.y.z：表示x是保持不变的，y和z永远安装最新的版本； 
- ~x.y.z：表示x和y保持不变的，z永远安装最新的版本；

### npm install 命令

安装npm包分两种情况：

- 全局安装（global install）： npm install webpack -g; 
- 项目（局部）安装（local install）： npm install webpack

全局安装

- 全局安装是直接将某个包安装到全局： 
- 比如yarn的全局安装： 
  - npm install webpack -g

但是很多人对全局安装有一些误会：

- 通常使用npm全局安装的包都是一些工具包：yarn、webpack等； 
- 并不是类似于 axios、express、koa等库文件； 
- 所以全局安装了之后并不能让我们在所有的项目中使用 axios等库；

### 项目安装

项目安装会在当前目录下生产一个 node_modules 文件夹，require查找会查找该文件夹

局部安装分为开发时依赖和生产时依赖：

```ruby
# 安装开发和生产依赖 
npm install axios 
npm i axios

# 开发依赖 
npm install webpack --save-dev 
npm install webpack -D 
npm i webpack –D

# 根据package.json安装依赖包 
npm install
```

### npm install 原理

![image-20230203101315133](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203101315133.png)

npm install会检测是有package-lock.json文件：

- 没有lock文件 
  - 分析依赖关系，这是因为我们可能包会依赖其他的包，并且多个包之间会产生相同依赖的情况； 
  - 从registry仓库中下载压缩包（如果我们设置了镜像，那么会从镜像服务器下载压缩包）； 
  - 获取到压缩包后会对压缩包进行缓存（从npm5开始有的）； 
  - 将压缩包解压到项目的node_modules文件夹中（前面我们讲过，require的查找顺序会在该包下面查找） 
- 有lock文件 
  - 检测lock中包的版本是否和package.json中一致（会按照semver版本规范检测）； 
    - 不一致，那么会重新构建依赖关系，直接会走顶层的流程； 
  - 一致的情况下，会去优先查找缓存 
    - 没有找到，会从registry仓库下载，直接走顶层流程； 
  - 查找到，会获取缓存中的压缩文件，并且将压缩文件解压到node_modules文件夹中；

### package-lock.json文件

- name：项目的名称； 
- version：项目的版本； 
- lockfileVersion：lock文件的版本； 
- requires：使用requires来跟踪模块的依赖关系； 
- dependencies：项目的依赖
  - 当前项目依赖axios，但是axios依赖follow-redireacts； 
  - axios中的属性如下： 
    - version表示实际安装的axios的版本； 
    - resolved用来记录下载的地址，registry仓库中的位置； 
    - requires记录当前模块的依赖； 
    - integrity用来从缓存中获取索引，再通过索引去获取压缩包文件；

### npm其他命令

卸载某个依赖包：

- npm uninstall package
- npm uninstall package --save-dev
- npm uninstall package -D

强制重新build

- npm rebuild

清除缓存

- npm cache clean

## yarn工具

yarn 是为了弥补 npm 的一些缺陷而出现的；

早期的npm存在很多的缺陷，比如安装依赖速度很慢、版本依赖混乱等等一系列的问题； 

虽然从npm5版本开始，进行了很多的升级和改进，但是依然很多人喜欢使用yarn；

![image-20230203101811556](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203101811556.png)

## cnpm工具

使用cnpm，并且将cnpm设置为淘宝的镜像：

```
npm install -g cnpm --registry=https://registry.npm.taobao.org 
cnpm config get registry # https://r.npm.taobao.org/
```

## npx工具

npx是npm5.2之后自带的一个命令

npx的原理非常简单，它会到当前目录的node_modules/.bin目录下查找对应的命令；

以webpack为例： 

- 全局安装的是webpack5.1.3 
- 项目安装的是webpack3.6.0 

如果我在终端执行 webpack --version使用的是哪一个命令呢？ 

- 显示结果会是 webpack 5.1.3，事实上使用的是全局的，为什么呢？ 
- 原因非常简单，在当前目录下找不到webpack时，就会去全局找，并且执行命令；

那么如何使用项目（局部）的webpack，npx之前常见的是两种方式： 

- 方式一：明确查找到node_module下面的webpack 
- 方式二：在 scripts定义脚本，来执行webpack；

```
// 方式一：在终端中使用如下命令（在项目根目录下）
./node_modules/.bin/webpack --version

// 方式二：修改package.json中的scripts
"scripts": {
	"webpack": "webpack --version" 
}
```

npx 出现后即可直接使用npx来解决这个问题

```
方式三：使用npx
npx webpack --version
```

## npm发布自己的包

- 注册npm账号：https://www.npmjs.com/ p选择sign up
- 在命令行登录：npm login
- 修改package.json
- 发布到npm registry上： npm publish
- 更新仓库：1.修改版本号(最好符合semver规范) 2.重新发布
- 删除发布的包： npm unpublish
- 让发布的包过期： npm deprecate