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

/*
let queue = Queens1()
queue.placeQueens(count: 8)
*/

/*
// 贪心算法，0-1背包
Knapsack.run { a, b in
    // 价值主导
//    return a.value > b.value
    
    // 重量主导
//    return a.weight < b.weight
    
    // 性价比主导
    return a.valueDensity > b.valueDensity
}
 */

/*
 // 最大子串
let arr: [Int] = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
print(MaxSubArray.maxSub3(nums: arr))
*/

/*
//找零钱
let num = CoinsNumber.coins3(n: 41)
//let num = CoinsNumber.coins(n: 41, faces:[1, 5, 20, 25])
print(num)
*/

/*
//最长上升子序列
let len = LC_300_最长上升子序列.lengthOfLIS(nums: [10, 2, 2, 5, 1, 7, 101, 18])
print(len)
 */

//let index = BruteForce.indexOf2(text: "abcdeabcfgabc", pattern: "abcfg")
let index = KMP.indexOf(text: "abcdeabcfgabc", pattern: "abcfg")
print(index)
