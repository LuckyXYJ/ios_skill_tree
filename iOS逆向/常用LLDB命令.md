## LLDB指令格式

```
<command> [<subcommand> [<subcommand>...]] <action> [-options [optionvalue]] [argument [argument...]]
```

- command : 命令
- subcommand：子命令
- action：命令操作
- options 命令选项
- argument： 命令参数

如给test函数设置断点 `breakpoint set -n test`

## help <command>

- 查看指令的用法
- 比如 ` help breakpoint`, ` help breakpoint set`

## expression <cmd-options> -- <expr>

- 执行一个表达式

  - <cmd-options> :  命令选项

  - --：命令选项结束符，表示所有命令选项已经设置完毕，如果没有命令选项。--可以省略

  - <expr>: 需要执行的表达式

    ```
    expression self.view.backgroundColor = [UIColor redColor]
    ```

    

- expression、expression -- 和指令print、p、call的效果一样

- expression -O -- 和指令 po的效果一样

## thread backtrace

- 打印线程的堆栈信息
- 和指令bt的效果一样

## thread return []

- 让函数直接返回某个值，不会执行断点后面的代码

## Frame variable []

- 打印当前栈帧的变量

## thread continue̵、continue̵c 、c

- 程序继续运行

## thread step-over、next、n

- 单步运行，把值函数当做整体一步执行

## thread step-in、 step、s

单步运行，遇到子函数会进入子函数

## thread step-out、finish 

直接执行完当前函数的所有代码，返回到上一个函数

## thread step-inst-over、 nexti、 ni

## thread step-inst、stepi、 si

## si、ni和s、n类似

- s、n是源码级别
- si、ni是汇编指令级别

## breakpoint set

- 设置断点
- breakpoint set -a函数地址
- breakpoint set -n函数名
  - breakpoint set -n test
  - breakpoint set -n touchesBegan:withEvent:
  - breakpoint set -n "-[ViewController touchesBegan:withEvent:]"
- breakpoint set -r 正则表达式
- breakpoint set -s 动态库 -n 函数名

## breakpoint list

列出所有的断点(每个断点都有自己的编号)

## breakpoint disable 断点编号

禁用断点.

## breakpoint enable 断点编号

启用断点

## breakpoint delete 断点编号

删除断点

## breakpoint command add 断点编号

给断点预先设置需要执行的命令,到触发断点时，就会按顺序执行

## breakpoint command list 断点编号

查看某个断点设置的命令

## breakpoint command delete 断点编号

删除某个断点设置的命令

## 内存断点

- 在内存数据发生改变的时候触发
- watchpoint set variable变量
  - `watchpoint set variable self->age`
- watchpoint set expression地址
  - `watchpoint set expression &(self->_ age)`
- watchpoint list
- watchpoint disable 断点编号
- watchpoint enable 断点编号
- watchpoint delete 断点编号
- watchpoint command add 断点编号
- watchpoint command list 断点编号
- watchpoint command delete 断点编号

## image lookup

- image lookup-t类型:查找某个类型的信息
- image lookup -a地址:根据内存地址查找在模块中的位置
- image lookup -n符号或者函数名:查找某个符号或者函数的位置

## image list

- 列出所加载的模块信息
- `image list -0 -f` 打印出模块的偏移地址、全路径

## 小技巧

- 敲Enter, 会自动执行上次的命令
- 绝大部分指令都可以使用缩写