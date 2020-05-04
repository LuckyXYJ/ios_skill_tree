## Row ， Column ， Stack 主轴方向

横向 纵向 层叠

## mainAxisAlignment 

关于主轴:

 * spaceBetween 剩下的空间平均分布到小部件之间
 * spaceAround  剩下的空间平均分布到小部件的周围
 * spaceEvenly  剩下的空间和小部件一起平均分布


## magin

margin: EdgeInsets.all(10), 全部设为10

## padding

padding: EdgeInsets.only(left: 30,right: 10,top: 10,bottom: 10),

## Positioned 绝对布局

Positioned(right: 0, child:<>)  
this.left,
this.top,
this.right,
this.bottom,
this.width,
this.height,

## 屏幕宽高

double ScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double ScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

## alignment 

alignment: Alignment(0.0, 0.0), //x,y
取值范围 -1 到 1。 （0，0） 为中心 

## AspectRatio 

AspectRatio(
    aspectRatio: 2 / 1,  //宽高比例
    child: Icon(
        Icons.add,
        size: 40,
    )),
),


## Expanded

比例布局
Expanded(flex: 1, child:<>)

## 绝对布局

height

width

## 流布局 

横、竖、层叠