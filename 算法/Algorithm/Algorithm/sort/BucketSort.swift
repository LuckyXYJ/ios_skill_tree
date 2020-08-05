//
//  BucketSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/24.
//

import Foundation

class BucketSort: ArraySort {
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 { return arr }
        var list = arr
        
        bucketSort(arr: &list)
        
        return list;
    }
    
    static func bucketSort(arr: inout [Int]) {
        
        var buckets = [[Int]].init(repeating: [], count: arr.count)
        
        for i in 0..<arr.count {
            
            let bucketIndex = (arr[i] * arr.count)/100
            var bucket = buckets[bucketIndex]
            bucket.append(arr[i])
            buckets[bucketIndex] = bucket
        }
        
        var index = 0
        for i in 0..<buckets.count {
            if buckets.count == 0 { continue }
            let blist = QuickSort.sort(arr: buckets[i])
            for n in blist {
                arr[index] = n
                index += 1
            }
        }
    }
}
