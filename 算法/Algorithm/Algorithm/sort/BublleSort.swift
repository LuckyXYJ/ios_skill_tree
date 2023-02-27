//
//  BublleSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/20.
//

import Foundation

/// 冒泡排序
class BublleSort: ArraySort {
    
    /// 冒泡排序
    static func sort(arr: [Int]) -> [Int] {
        if arr.count <= 1 {return arr}
        var list = arr;
        for end in (0..<list.count - 1).reversed() {
            for j in 0..<end {
                if list[j] > list[j+1] {
                    (list[j], list[j+1]) = (list[j+1], list[j])
                }
            }
        }
        return list
    }
    
    /// 冒泡排序优化，已完成排序的提前终止循环
    static func sort1(arr: [Int]) -> [Int] {
        if arr.count <= 1 {return arr}
        var list = arr;
        var sorted = true;
        for end in (0..<list.count - 1).reversed() {
            for j in 0..<end {
                if list[j] > list[j+1] {
                    (list[j], list[j+1]) = (list[j+1], list[j])
                    sorted = false
                }
            }
            if sorted{ break }
        }
        return list
    }
    
    /// 冒泡排序优化，尾部有序部分位置记录，减少比较次数
    static func sort2(arr: [Int]) -> [Int] {
        if arr.count <= 1 {return arr}
        var list = arr;
        for var end in (0..<list.count - 1).reversed() {
            
            var sortedIndex = 1;
            for j in 0..<end {
                if list[j] > list[j+1] {
                    (list[j], list[j+1]) = (list[j+1], list[j])
                    sortedIndex = j + 1;
                }
            }
            // 没有效果，swift的for循环中，修改end不影响整体循环流程
            end = sortedIndex;
        }
        return list
    }
}
