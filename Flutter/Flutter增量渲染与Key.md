## Flutter渲染

增量渲染，类似iOS中复用机制

## key

key本身是一个抽象类，有一个工厂和构造方法。ValueKey继承自 LocalKey

直接子类有：LocalKey 和 GlobalKey

## LocalKey

用来区分哪个Element要保留，哪个Element要删除。**diff算法**的核心所在

子类：

- ValueKey： 以值作为参数（数字，字符串）
- ObjectKey：以对象为参数
- UniqueKey: 创建唯一标识

## GlobalKey

帮助我们访问某个Widget的信息

