//
//  MaxSubArray.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/29.
//

import Foundation
//给定一个长度为 n 的整数序列，求它的最大连续子序列和

class MaxSubArray {
    
    // 难以理解地，以下三种最优解
    // 可以使用动态规划，继续优化，看MaxSubArray2
    // 分治
    static func maxSub3(nums: [Int]) -> Int {
            
        if nums.count == 0 { return 0 }
        return maxSub3(nums: nums, begin: 0, end: nums.count)
    }
    
    static func maxSub3(nums: [Int], begin: Int, end: Int) -> Int {
        
        if end - begin < 2 { return nums[begin] }
        let mid = (begin + end) >> 1
        
        var leftMax = nums[mid - 1]
        var leftSum = leftMax
        for i in (begin..<mid-1).reversed() {
            leftSum += nums[i]
            leftMax = max(leftMax, leftSum)
        }
        
        var rightMax = nums[mid]
        var rightSum = rightMax
        for i in (mid+1)..<end {
            rightSum += nums[i]
            rightMax = max(rightMax, rightSum)
        }
        
        return max(leftMax + rightMax, max(maxSub3(nums: nums, begin: begin, end: mid), maxSub3(nums: nums, begin: mid, end: end)))
    }
    
    // O(n^2)
    static func maxSub(nums: [Int]) -> Int {
            
        if nums.count == 0 { return 0 }
        var mx = 0;
        for begin in 0..<nums.count {
            var sum = 0
            for end in begin..<nums.count {
                sum += nums[end]
                mx = max(mx, sum)
            }
        }
        return mx
    }
    
    // 暴力出奇迹
    static func maxSub1(nums: [Int]) -> Int {
            
        if nums.count == 0 { return 0 }
        var mx = 0;
        for begin in 0..<nums.count {
            for end in begin..<nums.count {
                
                var sum = 0
                for i in begin...end {
                    sum += nums[i]
                }
                mx = max(mx, sum)
            }
        }
        return mx
    }
    
}
