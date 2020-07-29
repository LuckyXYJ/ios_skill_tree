//
//  RadixSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/24.
//

import Foundation

class RadixSort: ArraySort {
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 { return arr }
        var list = arr
        
        radixSort(arr: &list)
        
        return list;
    }
    
    static func radixSort(arr: inout [Int]) {
        var max = arr[0];
        for i in 0..<arr.count {
            if arr[i] > max {
                max = arr[i]
            }
        }
        
        var outPuts = [Int].init(repeating: 0, count: arr.count)
        var counts = [Int].init(repeating: 0, count: 10);
        
    }
}
