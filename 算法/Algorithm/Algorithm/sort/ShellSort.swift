//
//  ShellSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/24.
//

import Foundation

class ShellSort: ArraySort {
    static func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 { return arr }
        var list = arr
        // 步长随便写的
//        let stepList = sedgewichStepSequence(arr: list);
        let stepList = shellStepSequence(arr: list);
        
        ArrayPrint.printArr(arr: stepList)
        
        for i in stepList {
            shellSort(arr: &list, step: i);
        }
        return list;
    }
    
    static func shellSort(arr: inout [Int], step: Int) {
        // col 列，对每列进行排序
        for col in 0..<step {
            // 每个元素坐标为，col(列index) + step(步长) * 行数 index
            // col + step 即为该列下一行对应的元素
            for begin in stride(from: col + step, to: arr.count, by: step) {
                var cur = begin;
                // 当前cur位置元素,与上一行的元素大小对比
                // 小于前面的就移动，大于前面的结束
                // 逐个往前插入，类似于插入排序
                while cur > col && arr[cur] < arr[cur - step] {
                    (arr[cur], arr[cur - step]) = (arr[cur - step], arr[cur])
                    cur -= step;
                }
                
            }
        }
    }

    // 目前最好的的步长序列，有robert sedgewick提出
    // 最坏时间复杂度O(n^(4/3))
    static func sedgewichStepSequence(arr: [Int]) -> [Int] {
        var stepList: [Int] = []
        var k = 0, step = 0
        while(true) {
            if(k % 2 == 0) {
                let pow = Int(truncating: pow(2, k>>1) as NSNumber)
                step = 1+9*(pow*pow - pow)
            }else {
                let pow1 = Int(truncating: pow(2,(k-1)>>1) as NSNumber)
                let pow2 = Int(truncating: pow(2,(k+1)>>1) as NSNumber)
                step = 1+8*pow1*pow2 - 6*pow2
            }
            if step >= arr.count {break}
            stepList.insert(step, at: 0)
            k+=1;
        }
        return stepList
    }
    
    
    /// 希尔本人给出的序列，最坏情况时间复杂度 O(n^2)
    static func shellStepSequence(arr: [Int]) -> [Int]{
        var stepList: [Int] = []
        
        var step = arr.count
        
        var temp = step >> 1
        while temp > 0 {
            step = temp;
            temp = step >> 1
            stepList.append(step);
        }
        return stepList
    }
}
