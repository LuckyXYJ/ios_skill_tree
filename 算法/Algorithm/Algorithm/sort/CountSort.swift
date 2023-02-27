//
//  CountSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/24.
//

import Foundation

class CountSort: ArraySort {
    
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 { return arr }
        var list = arr
        
        countSort(arr: &list)
        
        return list;
    }
    
    static func countSort(arr: inout [Int]) {
        
        // 找出最大值，最小值。
        /**
         用来存储的数组区间可以选择 min -> max区间
         作用：
         - 可以对负数进行排序
         - 可以尽可能地降低空间复杂度
         */
        var max = arr[0];
        var min = arr[0];
        for value in arr {
            if value > max {
                max = value
            }
            if value < min {
                min = value
            }
        }
        
        // 将所有元素加入counts计数表中
        var counts:[Int] = [Int].init(repeating: 0, count: max - min + 1)
        for i in 0..<arr.count {
            counts[arr[i] - min] += 1;
        }
        
        // 每个元素位置存储数据 = 该元素出现次数+比该元素小的所有元素出现次数
        /**
         目的：将不稳定的排序变为稳定排序
         原理：统计完数据后，倒序遍历原数组，可以确定每个元素的具体位置。
         **/
        for i in 1..<counts.count {
            counts[i] += counts[i-1]
        }
        
        // 临时数组，保存结果
        // 每个位置，每取出一个元素，该位置计数-1。
        // 有了前部分优化后，位置计数-1即为当前元素所在位置
        var output:[Int] = [Int].init(repeating: 0, count: arr.count)
        for i in (0..<arr.count).reversed() {
            counts[arr[i] - min] -= 1;
            output[counts[arr[i] - min]] = arr[i]
        }
        
        // 结果数据依次存回原数组
        for i in 0..<arr.count {
            arr[i] = output[i]
        }
    }
}
