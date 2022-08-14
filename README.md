# 一、OC 
## 1、OC之对象

1. 什么是内存对齐，内存对齐规则是什么样的？
2. 内存对齐计算` (x + (8-1)) & ~(8-1) ` 和 ` (x + (8-1)) >> 3 << 3 `
3. 结构体实际占用内存计算，系统给该结构体开辟空间内存大小计算，他们的区别是什么？
4. class_getInstanceSize , malloc_size, sizeof 区别？
5. instance对象，class对象，mate-class对象的区别与关系? 在内存中各自存储哪些信息
6. ` - (Class)class` ，` + (Class)class `，` object_getClass(id _Nullable obj)  ` 的区别
7. 怎么判断一个Class对象是否为meta-class？
8. isa指针和superClass指针分别是如何指向的？

## 2、OC之类原理，iOS 类与对象原理

1. 类对象的结构，isa，superclass，cache，bits。
2. 什么是联合体(共用体)，什么是位域，isa包含哪些信息，怎么获取isa指针地址
3. class_rw_t，class_ro_t分别包含哪些信息，为什么这么设计
4. method_t包含哪些信息，存储在什么位置，分类添加同名方法时会执行哪个
5. property 和 ivars有什么区别，为什么说分类不能添加属性
6. isKindOfClass 和 isMemberOfClass的区别
7. objc_getClass,object_getClass，objc_getMetaClass区别
8. 方法缓存cache_t是怎么存储的，hash计算与buckets扩容实现方式
9. new与alloc/init的区别？

## 3、OC分类Category原理

1. Category底层结构是怎么样的
2. 为什么说不能添加属性？
3. Category加载过程？同名方法如何处理？
4. load方法和initialize的区别？
5. 怎么添加成员变量？
6. 关联对象是如何存储的？
7. 分类和扩展的区别是什么？

## 4、OC中Block本质

1. block是什么？封装了函数以及函数调用环境的OC对象
2. block分为哪几种类型？有什么区别
3. block变量捕获有哪些情况？auto，static，
4. ARC，MRC情况下定义block使用的属性关键字有什么区别，为什么
5. ARC环境下，哪些情况编译器会根据情况自动将栈上的block复制到堆上
6. block内部为什么不能修改局部变量，__block为什么能？
7. ` __block`有什么限制？`__block`不能修饰全局变量、静态变量（static）
8. ` __weak, __strong`分别有什么作用

## 5、OC之KVO原理

1. 什么是KVO？KVO 是如何实现的
2. 不调用set的情况下如何触发KVO，直接用_ivar修改属性值是否触发KVO？
3. 重复添加观察者，重复移除观察者会发生什么现象？
4. ` automaticallyNotifiesObserversForKey:` 和 `keyPathsForValuesAffectingValueForKey:`分别有什么作用
5. AFURLRequestSerialization为什么要用automaticallyNotifiesObserversForKey关闭一些方法的自动KVO

## 6、OC之KVC原理

1. 什么事KVC，常见的API有哪些
2. ` setValue:forKey: `方法查找顺序是什么样的
3. ` valueForKey:`方法的查找顺序是什么样的
4. accessInstanceVariablesDirectly方法有什么作用

## 7、OC内存管理

1. OC中内存分区从低到高是怎么样的？保留区，代码段，数据段，堆，栈，内核区
2. 各个分区分吧存储哪些内容？
3. OC内存管理方案有哪些？ARC，MRC的区别，Tagged Pointer是什么?自动释放池又是什么
4. Tagged Pointer能够存储哪些类型，怎么区分iOS平台还是Mac平台
5. 引用计数存储在什么位置？
6. delloc方法会进行哪些操作？
7. SideTable是什么，能够存储哪些数据，数据结构是怎么样的？
8. 自动释放池的底层结构是什么样的，怎么实现的？
9. Runloop和自动释放池的关系？
10. Copy 和 mutableCopy的区别是什么？
11. 属性关键字有哪些？什么情况下用copy
12. Block，NSTimer循环引用区别与解决方案？
13. weakTable 弱引用表是怎么实现的

## 8、OC中Runtime原理与使用

1. 什么是Runtime，有什么作用？常用在什么地方
2. OC方法查找机制是怎么样的？有什么缺点？
3. objc_msgSend分为哪几个阶段？每个阶段具体做了些什么？
4. 方法cache是怎么做的？有什么好处
5. OC与Swift在方法调用上有什么区别？
6. 动态方法解析过程中关键方法是哪个？` resolveInstanceMethod:`
7. 消息转发过程关键方法有哪几个？` forwardInvocation:`，` methodSignatureForSelector:`，` forwardInvocation`
8. @dynamic的作用是什么？
9. super xxxx]中super有什么作用？
10. Runtime的API有哪些？

## 9、OC中Runloop原理与使用

1. 什么是Runloop？有什么作用？常用来做什么？
2. Runloop与线程之间的关系？
3. Runloop在内存中如何存储？key是线程
4. Runloop相关的类有哪些？
5. CFRunLoopModeRef是什么？有哪几种mode?
6. Source0/Source1/Timer/Observer是什么，与mode有什么关系？
7. CFRunLoopObserverRef包含哪几种状态？
8. 如何监听RunLoop的所有状态？
9. Runloop具体流程？
10. 用户态和内核态是什么？
11. 线程保活怎么做？

## 10、OC中多线程实现与线程安全

1. iOS多线程方案有哪些？如何选择？有什么区别？
2. 串行队列，并行队列的区别？全局队列和主队列呢？
3. 同步任务和异步任务的区别？
4. 使用sync函数往当前串行队列中添加任务会发生什么现象？
5. 异步并发执行任务1、任务2，等任务1、任务2都执行完毕后，再回到主线程执行任务3怎么实现？
6. Group，`dispatch_barrier_async`，`dispatch_semaphore`分别用来做什么？
7. 多线程安全问题有哪些？如何解决
8. 自旋锁和互斥锁的区别？递归锁，条件锁是什么？
9. atomic，noatomic的区别？
10. iOS读写安全方案有哪些？读写锁pthread_rwlock，栅栏函数
11. dispatch_barrier_async 如果传入的是一个串行或是一个全局的并发队列会发生什么现象？

# 二、Swift

## 1、Swift数据类型，常量、变量、元组

1. 值类型和引用类型区别，swift中值类型有哪些，引用类型有哪些。和OC相比有什么区别？
2. Optional可选类型属于引用类型还是值类型？如何实现的
3. 常量和变量分别如何声明？
4. 可选类型解包方式有哪些？
5. 多重可选项的情况是怎么处理的？
6. 什么是可选链？可选链的结果是可选项么？
7. 什么是元祖，元祖能做什么？
8. 什么是字面量，字面量协议可以做什么？

## 2、Swift流程控制

1. for in 在Swift上有什么特点？
2. 什么是区间类型？跨间隔的区间怎么实现？stride
3. Swift中switch怎么实现贯穿效果？复合条件或fallthrouh
4. switch与元组结合有什么效果？元祖与where结合呢？
5. switch区间匹配？
6. guard..else与do..while有什么区别

## 3、Swift结构体，类，枚举

1. 枚举是否可以递归？indirect
2. 枚举值原始值和附加值分别是什么？内存占用怎么计算？
3. 结构体内存占用如何计算？
4. 结构体自定义初始化方法和自动生成的初始化方法有什么关系？
5. 结构体能否继承？如果改变property，需要怎么做？mutating
6. 类自动生成的初始化方法与结构体自动初始化方法有何区别？
7. struct 与 class有什么区别？值类型和引用类型，继承，初始化方法，属性值改变
8. 如何给结构体，类，枚举增加subscript下标？subscript可以用来做什么？

## 4、swift方法、闭包

1. 实例方法和类方法有什么区别？
2. 值类型的属性想要被自身的实例方法修改，怎么实现？mutating
3. 什么是闭包？闭包表达式是怎么样的？
4. 闭包作为参数时的缩写？什么是尾随闭包?
5. @autoclosure是什么？有什么作用？
6. Swift函数定义，函数重载，函数类型](https://www.jianshu.com/p/02efba7c0c49)

## 5、Swift属性，单例

1. 什么是计算属性，什么是存储属性？只读计算属性，延迟存储属性呢？
2. 枚举的原始值属于计算属性还是存储属性？
3. 什么是属性观察器？willSet，didSet
4. 实例属性和类型属性有什么区别？
5. Swift单例如何实现？
6. 存储类型属性有什么特点? 在什么时候初始化？多个线程同时访问呢？

## 6、swift 泛型，关联类型，协议类型，不透明类型

1. 泛型有什么作用？类型参数化
2. 什么是关联类型？有什么作用？给协议中用到的类型定义一个占位名称
3. 什么是协议类型，协议类型能否作为函数返回值？
4. 泛型类型如何约束？
5. 什么是不透明类型？some限制只能返回一种类型

## 7、swift运算符

1. 什么是溢出运算符？
2. 什么是运算符重载？
3. Equatable协议与`==`运算符有什么关系？Swift为哪些类型提供默认的 Equatable 实现？
4. 如何自定义新的运算符？全局作用域使用operator进行声明

## 8、Swift初始化器

1. 指定初始化器和便捷初始化器有什么区别？required
2. 重写父类指定初始化器和便捷初始化器有何区别？
3. 初始化器自动继承的规则？
4. 初始化器中赋值会触发属性观察器么？
5. 什么是反初始化器？deinit

## 9、Swift内存管理

1. swift 中内存管理方案？ARC引用类型有几种？strong、weak、unowned
2. Swift闭包循环引用如何产生，怎么解决？
3. 能否在定义闭包属性的同时引用self？lazy
4. 如果lazy属性是闭包调用的结果，是否需要考虑循环引用问题？
5. 什么是逃逸闭包?逃逸闭包能否捕获inout参数？@escaping
6. 什么是内存访问冲突？Conflicting Access to Memory
7. Swift中指针类型有哪几种？

## 10、Swift扩展

1. Swift中扩展与OC中分类有什么区别？能添加什么，不能添加什么？
2. Swift中扩展不能添加指定初始化器，不能添加反初始化器
3. 结构体自定义初始化器时不会生成默认初始化器。但是可以通过扩展实现两者同时存在
4. 扩展可以给协议提供默认实现，也间接实现**可选协议**的效果
5. 扩展可以给协议扩充协议中从未声明过的方法
6. 扩展中依然可以使用原类型中的泛型类型

## 11、Swift继承

1. 值类型并不支持继承，只有类支持继承
2. swift中是否有类似NSObject的基类？
3. Swift如何重写父类的下标、方法、属性？override
4. 如何限制不能被重写，或者不能被继承？final
5. 是否可以重写存储属性？
6. let修饰的属性能否重写？
7. static修饰的属性能否被重写？

## 12、Swift模式匹配

1. 什么是模式匹配？
2. 什么是通配符模式？标识符模式？值绑定模式？元组模式？枚举Case模式？可选模式？类型转换模式？表达式模式？
3. 通配符匹配中`_`和`_?`有什么区别？
4. 枚举Case模式中`if case`语句是什么？

## 13、Swift协议，面向协议编程，协议实现前缀

1. 什么是协议？协议能添加什么？
2. 协议中定义的内容是否必须全部都实现？如果想要实现可选协议呢？
3. 实现协议时的属性权限要不小于协议中定义的属性权限
4. 协议中定义的`init`方法，能否用`init?`来实现？
5. 枚举值如何进行遍历？遵守CaseIterable协议
6. 自定义打印需要遵循什么协议？CustomStringConvertible、 CustomDebugStringConvertible
7. Any、AnyObject有什么区别？如何定义只能类遵守的协议？
8. 什么是面向协议编程？解决了面向对象编程哪些问题？
9. 如何利用协议实现前缀效果？

## 14、Swift访问控制

1. Swift访问控制有哪几种访问级别？分别是什么？open，public，internal，fileprivate，private
2. 访问级别的使用准则？一个实体不可以被更低访问级别的实体定义
3. 元组类型，泛型类型的访问级别如何确定？
4. 类型的访问级别对其成员，嵌套类型的影响？
5. 子类重写成员的访问级别有什么限制？ ≥ 子类的访问级别，或者 ≥ 父类被重写成员的访问级别
6. 协议定义的方法，枚举类型的case等是否能单独设置访问级别？
7. **public类的默认初始化器是internal级别**。如果一个public类想在另一个模块调用编译生成的默认无参初始化器，必须显式提供public的无参初始化器

## 15、swift 错误处理

1. 如何自定义错误？遵守Error协议
2. 如何抛出异常，如何捕获异常？throw，do-catch
3. 可以使用try?、try!调用可能会抛出Error的函数，这样就不用去处理Error
4. 如何定义以任何方式（抛错误、return等）离开代码块前必须要执行的代码？defer
5. fatalError有作用？可以做什么？

## 16、swift与OC

1. MARK、TODO、FIXME
2. Swift条件编译？
3. Swift与OC互相调用？
4. Swift中String与NSString有什么区别？
5. 如何让Swift内容具有动态性？@objc dynamic
6. Swift资源名如何管理？

# 三、网络协议

## 1、网络协议基础概念

1. 网络分层？OSI 七层模型，五层模型，TCP/IP模型
2. 计算机连接方式有哪几种？什么是公网IP，私网IP？
3. 什么是Mac地址，相关命令有哪些？
4. IP地址？网络ID，主机ID？IP地址分类？子网，超网？
5. 网络分类？ISP？NAT？数字信号，模拟信号？信道？
6. 域名？DNS？代理服务器？CDN？HTTPDNS？网络爬虫
7. WebSocket与HTTP有和区别？WebService是什么？
8. REST规定了哪些约束?
9. Ipv6和Ipv4有什么区别？
10. 什么是流媒体技术？有哪些？RTP，RTCP，RTSP，RTMP，HLS(基于HTTP的流媒体网络传输协议，苹果公司出品)
11. 即时通讯协议有哪些，什么区别？XMPP，MQTT
12. 邮件相关协议有哪些？发SMTP，收POP、IMAP

## 2、物理层和数据链路层

1. 物理层做哪些事情？数字信号，模拟信号区别？信道有哪几种？
2. 数据链路层做了哪些事情？**封装成帧、透明传输、差错校验**
3. 数据链路层什么协议？CSMA/CD协议，PPP协议
4. Ethernet V2 标准帧格式？

## 3、网络层

1. 网络层做了什么？网络层数据包由什么组成？
2. 网络层首部包含哪些信息？

## 4、传输层

1. 传输层有哪些协议？
2. TCP，UDP有什么区别？连接性，可靠性，传输速率，资源消耗，首部占用空间，应用场景
3. TCP首部包含哪些信息？源/目的端口，序号，确认号，数据偏移，保留，标志位，窗口，检验和，紧急指针，选项，填充
4. 标志位有哪些，分别有什么作用？URG，ACK，PSH，RST，SYN，FIN
5. UDP首部包含哪些信息？源/目的端口，UDP长度，检验和
6. TCP**拥塞控制**，**可靠传输**，**流量控制**分别是什么?
   1. 流量控制：停止等待ARQ协议，连续ARQ协议 + 滑动窗口协议，SACK
   2. 流量控制：通过确认报文中窗口字段来控制发送方的发送速率 发送方的发送窗口大小不能超过接收方给出窗口大小
   3. 拥塞控制：慢开始，拥塞避免，快速重传，快速恢复
7. TCP如何建立链接，断开链接？为什么三次握手，四次挥手？为什么要有TIME-WAIT时间？

## 5、应用层

1. 应用层有哪些协议？
2. CDN，DNS，DHCP协议？
3. HTTP请求报文格式？响应报文格式？
4. HTTP请求方法有哪几种？get，post，delete，head，options，put，patch，trace，connect
5. 请求头字段有哪些？
6. 响应头字段有哪些？
7. HTTP状态码有哪些？
8. 缓存相关头部字段？form表单提交方式？

## 6、网络安全

1. 网络中面临哪几种安全威胁？
   1. 网络层：ARP，Dos，DDos
   2. 传输层：SYN，LAND
   3. 应用层：HTTP挟持
2. 什么是ARP欺骗？如何防护？
3. 什么是Dos攻击，DDoS攻击？如何防御？
4. 什么是SYN洪水攻击？怎么防护
5. 什么是LAND攻击？怎么防护
6. 对称加密和非对称加密有什么区别？分别又哪些加密算法
7. 如何防止数据被篡改？MD5，数字签名
8. 公钥加密和私钥加密的应用有什么区别？

## 7、HTTP发展历程，HTTPS

1. HTTP2相比1.1版本做了哪些优化？二进制传输，多路复用，设置优先级，头部压缩，服务器推送
2. HTTP2的存在的问题？队头阻塞，握手延迟
3. HTTP3做了哪些改进，还存在什么问题？TCP->UDP，QUIC链接迁移，操作系统内核CPU 负载
4. HTTP和HTTPS的关系与区别？SSL/TLS
5. HTTPS建立连接的过程？TLS握手过程
6. get和post的区别
7. 什么是中间人攻击，怎么避免？

## 8、网络协议常见问题

1. DNS 域名解析过程
2. TCP建立连接三次握手？为什么要三次握手，两次是否可以？三次握手可以携带数据吗？
3. 初始序列号（ISN）是什么，是固定的么？
4. 半连接队列？
5. 四次挥手的过程，及状态转换？为什么建立连接握手三次，关闭连接时需要是四次呢？
6. 为什么TIME_WAIT 状态需要经过 2MSL 才能返回到 CLOSE 状态？


# 四、iOS基础

## 1、iOS布局

1. iOS中布局方式有哪些？
2. 怎么通过NSLayoutConstraint给视图增加约束？constraintWithItem，constraintsWithVisualFormat
3. translatesAutoresizingMaskIntoConstraints和AutoresizingMask属性关系

## 2、Xcode 多环境配置

1. target，project，scheme分别是什么
2. 如何做多环境配置？target，Configuration，xcconfig文件
3. 手动配置和xcconfig文件优先级？
   1. 手动配置Target Build Setting
   2. Target中配置的xcconfig文件
   3. 手动配置Project Build Setting
   4. Project中配置的xcconfig文件
4. xcode常见宏有哪些？

## 3、iOS中符号

1. 什么是符号？
2. 符号表的种类？Symbol Table，String Table，Indirect Symbol Table
3. 符号区分？按存在空间划分，按照模块划分 ，功能划分
4. 什么是导⼊（Import）符号？导出（Export）符号？
5. strip命令是什么？间接符号不能删除？
6. Strip Style有哪几种选项？

## 4、Mach-O文件

1. mach-O文件是什么？.o文件是什么？
2. mach-O文件的格式是怎么样的？
3. 查看Mach-O文件信息的命令有哪些？
4. iOS生产Mach-O文件的过程
5. dyld加载流程

## 5、iOS动态库与静态库

1. 什么是库文件，iOS库文件有哪几种类型？.a、.dylib、.framework、.xcframework、.tbd、.swiftmodule
2. xcframework文件与framework文件相比有什么优势？
3. .tdb文件主要是用来做什么的？减少Xcode工程占用的空间⼤⼩
4. 什么是静态库，什么是动态库？有什么区别？

## 6、iOS编译命令

1. 创建静态库，创建静态库
2. ar命令。压缩与解压缩静态库
3. 合并静态库
4. install_name_tool命令，主要用来修改动态库rpath
5. 编译优化设置。release选择-Os,平衡代码⼤⼩和编译性能

## 7、多架构合并

1. 从模拟器包中分离出x86-64？
2. 合并SYTimer-x86_64 和 iOS包（arm64）
3. 合并xcframework

## 8、链接静态库.a生成可执行文件

1. 静态库冲突如何解决

## 9、链接动态库.dylib生成可执行文件

1. 如何修改install_name或者生产dylib时指定install_name

## 10、静动态库相互链接

1. 动-动，动-静，静-动，静-静
2. 动动情况下，反向依赖情况，编译时动态库找不到符号怎么处理？通过 -U <符号 >，来指定⼀个符号的是动态查找符号。
3. 动动情况下，app跨库使用符号？ reexport_framework 或者 -reexport_l 重新将动态库B 通过动态库A导出给app
4. 动静如何隐藏静态库的符号？通过 `-hidden-l<libraryname>`隐藏静态库的全局符号。
5. 静静情况，app并不知道静态库B 的位置和名称。
   1. 通过cocoapods将静态库 B 引入到app中
   2. ⼿动配置静态库B 的位置和名称
6. 静动情况，动态库B的默认路径？动态库B的路径 = App的rpath + 动态库B的install_name
   1. 通过Cocoapods将动态库B 引⼊到App内：
   2. 配置app的rpath，并通过脚本将动态库B引入到app内

## 11、module,apinotes文件及swift库

1. 什么是module文件，如何生成？
2. module.modulemap文件用来做什么？文件格式怎样？module.modulemap 用来描述头文件与module之间映射的关系
3. swift库使用OC代码的方式？modulemap，协议
4. OC映射到Swift方式

## 12、iOS事件传递

1. 如何查找响应者，事件如何传递
2. 事件处理流程
3. 扩大按钮的点击区域
4. 子view超出了父view的bounds响应事件
5. 如果一个Button被一个View盖住了，在触摸View时，希望该Button能够响应事件
6. 特殊的UIScrollView，frame外响应滑动事件

# 五、iOS逆向

## 1、逆向思路

1. 界面分析。Cycript、Reveal
2. 代码分析。MachOView、class-dump、Hopper Disassembler、ida
3. 动态调试。debugserver、LLDB
4. 代码编写。代码注入，重签名，打包

## 2、ios签名机制

## 3、Mach-O，ASLR

## 4、LLVM

## 5、OpenSSH登录iPhone，sh脚本文件

## 6、代码混淆

## 7、越狱

## 8、脱壳

## 9、Cycript调试，*Reveal调试*

## 10、class-dump

## 11、动态调试debugserver，常用LLDB命令

## 12、dyld shared cache 动态库共享缓存

## 13、Hopper Disassmbler，汇编

## 14、重签名

## 15、可执行文件-权限

## 16、Theos

## 17、tweak修改应用，tweak修改钉钉实战记录

## 18、代码混淆

# 六、iOS视觉

## 1、OpenGL名词

## 2、OpenGL固定管线

## 3、OpenGL图元

## 4、OpenGL3D数学

## 5、OpenGL渲染架构

## 6、OpenGL深度测试，Zfighting问题，多边形偏移

## 7、OpenGL正背面剔除

## 8、OpenGL ES

## 9、OpenGL ES GLSL

## 10、OpenGL ES 几何图形渲染

## 11、OpenGLES 光照计算

## 12、Metal

## 13、Metal_AVAssetReader

## 14、GPUImage与CoreImage

## 15、GLKit

## 16、CoreAnimation

## 17、图形API

## 18、滤镜处理

# 七、音视频开发

1、声音

2、图像

3、音频录制与播放编码

4、音频重采样

5、ACC编码

6、ACC编码操作

7、ACC解码操作

8、PCM转WAV

9、视频录制与播放编码

10、FFmpeg

11、FFmpeg音视频录制

12、H.264编码

13、H.264编码操作

14、H.264解码操作

15、YUV

16、流媒体
