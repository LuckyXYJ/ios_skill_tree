//
//  HeapSort.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/20.
//

import Foundation

class HeapSort: ArraySort {
    
    static var heapSize = 0
    
    static func sort(arr: [Int]) -> [Int] {
        //1、构建大顶堆
        if arr.count <= 1 {return arr}
        var list = arr;
        heapSize = arr.count
        for i in (0..<heapSize>>1).reversed() {
            siftDown(arr: &list, index: i);
        }
        while(heapSize > 1) {
            heapSize -= 1;
            list.swapAt(0, heapSize)
            siftDown(arr: &list, index: 0);
        }
        return list
    }
    
    //调整大顶堆（仅是调整过程，建立在大顶堆以构建的基础上）
    static func siftDown(arr : inout [Int], index : Int){
        var tempIndex = index;
        
        let temp = arr[tempIndex];
        let half = heapSize >> 1
        while tempIndex < half {
            var childIndex = (tempIndex << 1)+1
            var child = arr[childIndex]
            
            let rightIndex = childIndex + 1
             
            if rightIndex < heapSize && arr[rightIndex] > child {
                
                child = arr[rightIndex];
                childIndex = rightIndex;
            }
            
            if temp > child { break }
            
            arr[tempIndex] = child;
            tempIndex = childIndex
        }
        arr[tempIndex] = temp
    }
}


class HeapSort1: ArraySort {
    
    static func sort(arr: [Int]) -> [Int] {
        //1、构建大顶堆
        if arr.count <= 1 {return arr}
        var list = arr;
        
        //从二叉树的一边的最后一个结点开始
        for i in (0...(list.count/2-1)).reversed() {
            //从第一个非叶子结点从下至上，从右至左调整结构
            
            HeapSort1.adjustHeap(arr: &list, i: i, length: list.count)
        }
        //2、调整堆结构+交换堆顶元素与末尾元素
        for j in (1...(list.count-1)).reversed() {
            //将堆顶元素与末尾元素进行交换
            list.swapAt(0, j)
            //重新对堆进行调整
            HeapSort1.adjustHeap(arr: &list, i: 0, length: j)
        }
        
        return list;
    }
    
    //调整大顶堆（仅是调整过程，建立在大顶堆以构建的基础上）
    static func adjustHeap(arr : inout [Int], i : Int, length : Int){
        var index = i
        //取出当前元素i
        let tmp = arr[index]
        var k = 2*index+1
        //从i结点的左子节点开始，也就是2i+1处开始
        while k < length {
            //如果左子节点小于右子节点，k指向右子节点
            if k+1<length && arr[k]<arr[k+1]{
                k += 1
            }
            //如果子节点大于父结点，将子节点值赋给父结点，不用进行交换
            if arr[k]>tmp {
                arr[index] = arr[k]
                //记录当前结点
                index = k
            }else{
                break
            }
            //下一个结点
            k = k*2+1
        }
        //将tmp值放到最终的位置
        arr[index] = tmp
    }
}
