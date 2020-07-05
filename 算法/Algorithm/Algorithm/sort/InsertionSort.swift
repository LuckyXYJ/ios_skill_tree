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

/// 插入排序优化2，在优化1的基础上，使用二分查找，减少对比次数
class InsertionSort2: ArraySort {
    
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 {return arr}
        var list = arr
        for i in 1..<list.count {
            let dest = InsertionSort2.search(arr: list, index: i)
            InsertionSort2.insert(arr: &list, source: i, dest: dest)
        }
        return list
    }
    
    static func insert(arr: inout [Int], source: Int, dest: Int) {
        
        if dest == source { return }
        let temp = arr[source];
        for i in ((dest+1)...source).reversed() {
            arr[i] = arr[i - 1];
        }
        arr[dest] = temp
    }
 
    static func search(arr: [Int], index: Int) -> Int {
        var begin = 0
        var end = index
        
        while(begin < end) {
            let mid = (begin + end) >> 1
            if (arr[mid] > arr[index]) {
                end = mid
            } else {
                begin = mid + 1
            }
        }
        return begin
    }
}
