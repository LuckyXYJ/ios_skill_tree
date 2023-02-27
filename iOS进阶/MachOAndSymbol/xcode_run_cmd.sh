#!/bin/sh


RunCommand() {
  #判断全局字符串VERBOSE_SCRIPT_LOGGING是否为空。-n string判断字符串是否非空
  #[[是 bash 程序语言的关键字。用于判断
  if [[ -n "$VERBOSE_SCRIPT_LOGGING" ]]; then
    #作为一个字符串输出所有参数。使用时加引号"$*" 会将所有的参数作为一个整体，以"$1 $2 … $n"的形式输出所有参数
      if [[ -n "$TTY" ]]; then
          echo "♦ $@" 1>$TTY
      else
          echo "♦ $*"
      fi
      echo "------------------------------------------------------------------------------" 1>$TTY
  fi
  #与$*相同。但是使用时加引号，并在引号中返回每个参数。"$@" 会将各个参数分开，以"$1" "$2" … "$n" 的形式输出所有参数
  if [[ -n "$TTY" ]]; then
        eval "$@" &>$TTY
  else
      "$@"
  fi
  #显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
  return $?
}

EchoError() {
    #在shell脚本中，默认情况下，总是有三个文件处于打开状态，标准输入(键盘输入)、标准输出（输出到屏幕）、标准错误（也是输出到屏幕），它们分别对应的文件描述符是0，1，2
    # >  默认为标准输出重定向，与 1> 相同
    # 2>&1  意思是把 标准错误输出 重定向到 标准输出.
    # &>file  意思是把标准输出 和 标准错误输出 都重定向到文件file中
    # 1>&2 将标准输出重定向到标准错误输出。实际上就是打印所有参数已标准错误格式
    if [[ -n "$TTY" ]]; then
        echo "$@" 1>&2>$TTY
    else
        echo "$@" 1>&2
    fi
    
}

RunCMDToTTY() {
    if [[ ! -e "$TTY" ]]; then
        EchoError "=========================================="
        EchoError "ERROR: Not Config tty to output."
        exit -1
    fi
    # CMD = 运行到命令
    # CMD_FLAG = 运行到命令参数
    # TTY = 终端
    if [[ -n "$CMD" ]]; then
        RunCommand $CMD
    else
        EchoError "=========================================="
        EchoError "ERROR:Failed to run CMD. THE CMD must not null"
    fi
}


RunCMDToTTY
