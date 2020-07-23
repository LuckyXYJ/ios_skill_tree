//
//  QuickSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/22.
//

import Foundation

class QuickSort: ArraySort {
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 { return arr }
        var list = arr
        quckSort(arr: &list, left: 0, right: arr.count)
        return list
    }
    
    static func quckSort(arr: inout [Int], left: Int, right: Int) {
        
        if right - left < 2 { return }
        
        let pivot = pivotIndex(arr: &arr, left: left, right: right)
        
        quckSort(arr: &arr, left: left, right: pivot)
        quckSort(arr: &arr, left: pivot + 1, right: right)
        
    }
    
    static func pivotIndex(arr: inout [Int], left: Int, right: Int) -> Int {
        
        let random = Int.random(in: 0..<(right-left))
        (arr[left], arr[left + random]) = (arr[left + random], arr[left])
        
        var begin = left
        var end = right
        
        let temp = arr[begin];
        end -= 1
        
        while begin < end {
            
            while begin < end {
                if temp < arr[end] {
                    end -= 1
                }else {
                    arr[begin] = arr[end];
                    begin += 1
                    break
                }
            }
            
            while begin < end {
                if temp > arr[begin] {
                    begin += 1
                }else {
                    arr[end] = arr[begin];
                    end -= 1
                    break
                }
            }
        }
        arr[begin] = temp
        return begin
    }
}
