//
//  ArraySort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/19.
//

import Foundation

class ArraySort {
    
    static func bublleSort(arr: [Int]) -> [Int] {
        var list = arr;
        for end in (1..<list.count - 1).reversed() {
            for j in 0...end {
                if list[j] > list[j+1] {
                    (list[j], list[j+1]) = (list[j+1], list[j])
                }
            }
        }
        return list
    }
    
    static func bublleSort1(arr: [Int]) -> [Int] {
        var list = arr;
        var sorted = true;
        for end in (1..<list.count - 1).reversed() {
            for j in 0...end {
                if list[j] > list[j+1] {
                    (list[j], list[j+1]) = (list[j+1], list[j])
                    sorted = false
                }
            }
            if sorted{ break }
        }
        return list
    }
    
    static func bublleSort2(arr: [Int]) -> [Int] {
        var list = arr;
        
        for var end in (1..<list.count - 1).reversed() {
            
            var sortedIndex = 1;
            for j in 0...end {
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


