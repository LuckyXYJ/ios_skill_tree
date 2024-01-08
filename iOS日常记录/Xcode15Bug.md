## Assertion failed

Assertion failed: (false && "compact unwind compressed function offset doesn't fit in 24 bits"), function operator(), file Layout.cpp, line 5758.

**解决方法：Other Link Flags 添加-ld64 或者 -ld_classic**

**路径：Build Settings -> Linking - General -> Other Link Flags** **添加-ld64 或者 -ld_classic**