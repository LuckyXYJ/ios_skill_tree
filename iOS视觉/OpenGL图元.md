## 图元

|图元              |描述                                                         |
| ----------------- | ------------------------------------------------------------ |
| GL_POINTS         | `每个顶点在屏幕上都是单独点 `                                |
| GL_LINES          | 每⼀一对顶点定义⼀一个线段                                   |
| GL_LINE_STRIP     | `⼀一个从第⼀一个顶点依次经过每⼀一个后续顶点⽽而绘制的线条 ` |
| GL_LINE_LOOP      | 和GL_LINE_STRIP相同,但是最后⼀一个顶点和第⼀一个顶点连接起来了了. |
| GL_TRIANGLES      | 每3个顶点定义⼀一个新的三⻆角形                              |
| GL_TRIANGLE_STRIP | 共⽤用⼀一个条带(strip)上的顶点的⼀一组三⻆角形              |
| GL_TRIANGLE_FAN   | 以⼀一个圆点为中⼼心呈扇形排列列,共⽤用相邻顶点的⼀一组三⻆角形 |

![image-20220714200855466](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220714200855466.png)