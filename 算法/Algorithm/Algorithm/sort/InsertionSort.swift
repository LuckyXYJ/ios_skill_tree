//
//  InsertionSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/21.
//

import Foundation

/// 插入排序
class InsertionSort: ArraySort {
    
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 {return arr}
        var list = arr
        for i in 1..<list.count {
            var index = i
            while index > 0 && list[index] < list[index - 1]{
                list.swapAt(index, index - 1)
                index -= 1
            }
        }
        return list
    }
}


/// 插入排序优化1， 将逐个交换，转换为挪动
class InsertionSort1: ArraySort {
    
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 {return arr}
        var list = arr
        for i in 1..<list.count {
            var index = i
            let temp = list[index];
            while index > 0 && temp < list[index - 1]{
                list[index] = list[index - 1]
                index -= 1
            }
            list[index] = temp
        }
        return list
    }
}
