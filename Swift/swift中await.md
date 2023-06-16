## Swift中await

在 Swift 中，await 是异步/同步代码的新关键字。它通常与 async 一起使用，起到等待异步任务完成的作用。

使用 await 的过程如下：

1. 首先，定义一个异步函数：该函数必须标记为 `async`，并将一个或多个异步任务封装在其中，例如网络请求、文件读取等。

```
    func fetchData() async throws -> Data { 
        // 发起网络请求，返回数据 
    }
```

2. 接着，在另一个异步函数中调用此函数，并使用 `await` 进行处理。此时需要加上 `try` 关键字，因为 fetchData() 函数带有可能会抛出错误的 `throws`。

```
    async func doSomeWork() {
        do {
            let data = try await fetchData()
            // 处理获取到的数据
        } catch {
            // 处理错误
        }
    }
```

在上面的示例中，`await fetchData()` 表示等待 fetchData() 函数执行完成，并将结果赋给 `data` 变量，如果 fetchData() 抛出了错误，则会被 `catch` 语句捕获。

需要注意的是，在异步函数中使用 `await` 来等待另一个异步函数结束时，该异步函数的返回类型必须是一个 Future 类型，表明这个函数是一个异步任务，可以异步执行。

在Swift 5.5中，可以使用 Structured Concurrency 的方式来管理和处理异步代码中的错误，它基于 async/await 和 Task API，并提供了更好的异常处理机制以及自动化内存管理。