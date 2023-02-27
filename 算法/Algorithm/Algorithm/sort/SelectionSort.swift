//
//  SelectionSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/20.
//

import Foundation

/// 选择排序
class SelectionSort: ArraySort {
    static func sort(arr: [Int]) -> [Int] {
        if arr.count <= 1 {return arr}
        var list = arr;
        for end in (0..<list.count-1).reversed(){
            var maxIndex = 0;
            for start in 0..<end {
                if list[start] > list[maxIndex] {
                    maxIndex = start;
                }
            }
            (list[maxIndex], list[end]) = (list[end], list[maxIndex])
        }
        return list
    }
}
