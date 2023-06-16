## CGBlendMode

CGBlendMode 是 iOS 开发中用于指定图形混合模式的枚举类型。它定义了不同的混合模式，可以用于在绘制图形时实现不同的效果

各种混合模式的意思：

1. kCGBlendModeNormal：正常混合，使用源颜色和背景颜色相加来创建混合颜色。
2. kCGBlendModeMultiply：通过颜色混合来创建阴影效果，使用源颜色和背景颜色相乘来创建混合颜色。
3. kCGBlendModeScreen：通过颜色反转来混合颜色，从而调整图片的亮度和阴影。使用源颜色和背景颜色相反的相乘结果来创建混合颜色。
4. kCGBlendModeOverlay：叠加混合模式，通过处理混合的前景色和背景色来创建更丰富的图片效果。如果源颜色较亮，会将背景颜色加深；如果源颜色较暗，会将背景颜色变浅。
5. kCGBlendModeDarken：暗化混合模式，使用前景和背景颜色的较暗色。
6. kCGBlendModeLighten：亮化混合模式，使用前景和背景颜色的较亮色。
7. kCGBlendModeColorDodge：将源颜色清零或加强，用以调整亮度和饱和度。
8. kCGBlendModeColorBurn：将源颜色加深或减弱，用以调整亮度和饱和度。
9. kCGBlendModeHardLight：使用源颜色的亮度来调整背景颜色，同时使用源颜色的亮度和饱和度来调整前景颜色。
10. kCGBlendModeSoftLight：类似于 Overlay 模式，也是前景和背景颜色混合来创建更柔和的图片效果，但它使用的不是简单的相加或相乘，而是使用一个特殊的公式来计算混合颜色。
11. kCGBlendModeDifference：使用前景和背景颜色相减来计算混合颜色。
12. kCGBlendModeExclusion：类似于 Difference 模式，但使用的公式略有不同。
13. kCGBlendModeHue：保留背景颜色和亮度，用前景颜色的色调替换背景颜色。
14. kCGBlendModeSaturation：保留背景颜色和亮度，使用前景颜色的饱和度来替换背景颜色。
15. kCGBlendModeColor：保留背景颜色和亮度，使用前景颜色的色值来替换背景颜色。
16. kCGBlendModeLuminosity：保留背景颜色的饱和度和色调，使用前景颜色的亮度来替换背景颜色的亮度。
17. kCGBlendModeClear：清空混合模式，用于将目标图形设置为透明。
18. kCGBlendModeCopy：使用前景颜色替换背景颜色，忽略背景颜色的透明度。
19. kCGBlendModeSourceIn：将源图形和目标图形相交的部分的颜色基于源图形颜色的透明度进行混合。
20. kCGBlendModeSourceOut：将源图形和目标图形相交的部分的颜色基于源图形颜色的透明度进行混合，但是混合结果是反转的。

这些混合模式可以用于绘制颜色、图片、渐变等，实现各种个性化、丰富多彩的视觉效果。