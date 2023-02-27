//
//  LC_300_最长上升子序列.swift
//  Algorithm
//
//  Created by xingyajie on 2022/12/1.
//

import Foundation

class LC_300_最长上升子序列 {
    
    // 将每个元素往前面堆叠
    /*
     - 把每个数字看做是一张扑克牌，从左到右按顺序处理每一个扑克牌
     - 将它压在（从左边数过来）第一个牌顶 ≥ 它的牌堆上面
     - 如果找不到牌顶 ≥ 它的牌堆，就在最右边新建一个牌堆，将它放入这个新牌堆中
     - 当处理完所有牌，最终牌堆的数量就是最长上升子序列的长度
     */
    static func lengthOfLIS(nums: [Int]) -> Int {
        if nums.count == 0 { return 0 }
        var top = [Int].init(repeating: 0, count: nums.count)
        var len = 0
        for num in nums {
            var begin = 0
            var end = len
            while begin < end {
                var mid = (begin + end) >> 1
                if num <= top[mid] {
                    end = mid
                }else {
                    begin = mid + 1
                }
            }
            top[begin] = num
            if begin == len {
                len += 1
            }
        }
        return len
    }
    
    // 动态规划实现，空间复杂度O(n), 时间复杂度O(n^2)
    static func lengthOfLIS1(nums: [Int]) -> Int {
        if nums.count == 0 { return 0 }
        var dp = [Int].init(repeating: 1, count: nums.count)
        var mx = 1
        for i in 1..<dp.count {
            for j in 0..<i {
                
                if nums[i] <= nums[j] { continue }
                dp[i] = max(dp[i], dp[j] + 1)
            }
            mx = max(dp[i], mx)
        }
        return mx
    }
}
