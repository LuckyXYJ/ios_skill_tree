## Cookie

Cookie总是保存在客户端中，按在客户端中的存储位置，Cookie可以分为**内存Cookie**和**硬盘Cookie**。

- 内存Cookie由浏览器维护，保存在内存中，浏览器关闭时Cookie就会消失，其存在时间是短暂的； 
- 硬盘Cookie保存在硬盘中，有一个过期时间，用户手动清理或者过期时间到时，才会被清理；

默认情况下cookie是内存cookie.

有设置过期时间，并且过期时间不为0或者负数的cookie，是硬盘cookie，需要手动或者到期时，才会删除；

## cookie常见的属性

cookie的生命周期：

- 默认情况下的cookie是内存cookie，也称之为会话cookie，也就是在浏览器关闭时会自动被删除；
- 我们可以通过设置expires或者max-age来设置过期的时间；
  - expires：设置的是Date.toUTCString()，设置格式是;expires=date-in-GMTString-format； 
  - max-age：设置过期的秒钟，;max-age=max-age-in-seconds (例如一年为60*60*24*365)；

cookie的作用域：（允许cookie发送给哪些URL）

- Domain：指定哪些主机可以接受cookie
  - 如果不指定，那么默认是 origin，不包括子域名。 
  - 如果指定Domain，则包含子域名。例如，如果设置 Domain=mozilla.org，则 Cookie 也包含在子域名中（如developer.mozilla.org）。
- Path：指定主机下哪些路径可以接受cookie
  - 例如，设置 Path=/docs，则以下地址都会匹配： 
    - /docs 
    - /docs/Web/ 
    - /docs/Web/HTTP

## 客户端设置cookie

```
console.log(document.cookie);

document.cookie = "name=xxx"
document.cookie = "age=18"

//设置cookie，同时设置过期时间（默认单位是秒钟）
document.cookie = "name=xxx;max-age=1800"
```

