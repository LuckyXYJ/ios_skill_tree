//
//  main.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/19.
//

import Foundation

/*
 
 
var array: [Int] = [2,5,3,1,4,8,10,7,6,9,11,12,21,35,12,6]

//let arr = BublleSort.sort(arr: array);
let arr = RadixSort1.sort(arr: array);
ArrayPrint.printArr(arr: arr);

// 桶排序需要对数据根据特征划分桶
var bArray: [Int] = [33, 51, 27, 81, 43, 39, 38, 72]
let arr1 = BucketSort.sort(arr: bArray)
ArrayPrint.printArr(arr: arr1);

 */

/*
 // 斐波那契数列
let num = fibRecursion6.fib(50)
print(num)
*/

/*
// 汉诺塔
hanoiRecursion.hanoi(n: 5, p1: "A", p2: "B", p3: "C")
*/

let queue = Queens1()
queue.placeQueens(count: 8)
