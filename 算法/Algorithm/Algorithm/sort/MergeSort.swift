//
//  MergeSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/21.
//

import Foundation

class MergeSort: ArraySort {
    
    static var tempList: [Int] = []
    
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 {return arr}
        var list = arr
        
        MergeSort.divide(arr: &list, begin: 0, end: list.count)
        
        return list
    }
    
    static func divide(arr: inout [Int], begin: Int, end: Int) {
        
        if end - begin < 2 { return }
        let mid = (begin + end) >> 1
        divide(arr: &arr, begin: begin, end: mid)
        divide(arr: &arr, begin: mid, end: end)
        
        MergeSort.merge(arr: &arr, begin: begin, mid: mid, end: end)
    }
    
    static func merge(arr: inout [Int], begin: Int, mid: Int, end: Int) {
        var li = 0
        let le = mid - begin
        var ri = mid
        let re = end
        var ai = begin
        
        MergeSort.tempList = []
        for i in li..<le {
            MergeSort.tempList.append(arr[begin + i])
        }
        
        while(li < le) {
            if ri < re && arr[ri] < arr[li] {
                arr[ai] = arr[ri]
                ai += 1
                ri += 1
            }else {
                arr[ai] = MergeSort.tempList[li]
                ai += 1
                li += 1
            }
        }
    }
}

