//
//  字符串中子串位置.swift
//  Algorithm
//
//  Created by xingyajie on 2022/12/1.
//

import Foundation


/// 蛮力递归
class BruteForce {

    /// - Parameters:
    ///   - text: 文本字符串
    ///   - pattern: 需要匹配的子串
    /// - Returns: index
    static func indexOf(text: String, pattern: String) -> Int {
        if text.count == 0 || pattern.count == 0 {
            return -1
        }
        
        var ti = 0
        var pi = 0
        
        while ti < text.count && pi < pattern.count {
            
            if text[text.index(text.startIndex, offsetBy: ti)] == pattern[pattern.index(pattern.startIndex, offsetBy: pi)] {
                ti += 1
                pi += 1
            } else {
                ti -= pi - 1
                pi = 0
            }
        }
        return pi == pattern.count ? ti - pi : -1
    }
    
    // 对以上进行优化，在长度不足的情况下提前结束
    static func indexOf1(text: String, pattern: String) -> Int {
        if text.count == 0 || pattern.count == 0 {
            return -1
        }
        
        var ti = 0
        var pi = 0
        while ti < text.count && pi < pattern.count {
            
            if text[text.index(text.startIndex, offsetBy: ti)] == pattern[pattern.index(pattern.startIndex, offsetBy: pi)] {
                ti += 1
                pi += 1
            } else {
                ti -= pi - 1
                pi = 0
                
                if(text.count - ti < pattern.count) {
                    break
                }
            }
        }
        return pi == pattern.count ? ti - pi : -1
    }
    
    
    // 蛮力方法 2
    static func indexOf2(text: String, pattern: String) -> Int {
        let tlen = text.count
        let plen = pattern.count
        if tlen == 0 || plen == 0 || tlen < plen {
            return -1
        }
        let tmax = tlen - plen
        var pi = 0
        for ti in 0...tmax {
            pi = 0
            while pi < plen {
                if text[text.index(text.startIndex, offsetBy: ti + pi)] == pattern[pattern.index(pattern.startIndex, offsetBy: pi)] {
                    pi += 1
                }else {
                    break
                }
            }
            if pi == plen {
                return ti
            }
        }
        return -1
    }
}
