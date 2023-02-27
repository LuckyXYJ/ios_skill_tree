//
//  MaxSubArray2.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/30.
//

import Foundation

class MaxSubArray2 {
    
    // 时间复杂度O(n), 空间复杂度 O（n）,空间复杂度可以继续优化
    static func maxSub1(nums: [Int]) -> Int {
        
        if nums.count == 0 { return 0 }
        
        var dp = [Int].init(repeating: 0, count: nums.count)
        var mx = nums[0]
        dp[0] = nums[0]
        for i in 1..<nums.count {
            let prev = dp[i - 1]
            
            if prev > 0 {
                dp[i] = prev + nums[i]
            }else {
                dp[i] = nums[i]
            }
            mx = max(mx, dp[i])
        }
        
        return mx
    }
    
    // 时间复杂度O(n), 空间复杂度 O(1)
    static func maxSub(nums: [Int]) -> Int {
        
        if nums.count == 0 { return 0 }
        var mx = nums[0]
        var dp = nums[0]
        for i in 1..<nums.count {
            if dp > 0 {
                dp = dp + nums[i]
            }else {
                dp = nums[i]
            }
            mx = max(mx, dp)
        }
        return mx
    }
    
    static func maxSub3(nums: [Int]) -> Int {
    
        var mx = 0
        var dp = 0
        for num in nums {
            if dp > 0 {
                dp = dp + num
            }else {
                dp = num
            }
            mx = max(mx, dp)
        }
        return mx
    }
    
}
