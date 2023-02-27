//
//  LC_88_合并两个有序数组.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/21.
//

import Foundation

class LC_88_合并两个有序数组 {
    // 合并后数组不应由函数返回，而是存储在数组 nums1 中。为了应对这种情况，nums1 的初始长度为 m + n
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var ni = n - 1
        var mi = m - 1
        var ai = m + n - 1
        while ni >= 0 {
            if mi >= 0 && nums1[mi] > nums2[ni] {
                nums1[ai] = nums1[mi]
                ai -= 1
                mi -= 1
            }else {
                nums1[ai] = nums2[ni]
                ai -= 1
                ni -= 1
            }
        }
    }
}
