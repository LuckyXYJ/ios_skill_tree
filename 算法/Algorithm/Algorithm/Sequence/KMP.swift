//
//  KMP.swift
//  Algorithm
//
//  Created by xingyajie on 2022/12/1.
//

import Foundation

class KMP {
    static func indexOf(text: String, pattern: String) -> Int {
        let tlen = text.count
        let plen = pattern.count
        if tlen == 0 || plen == 0 || tlen < plen {
            return -1
        }
        let next = next(pattern: pattern)
        
        var ti = 0, pi = 0
        let tmax = tlen - plen
        
        while pi < plen && ti - pi <= tmax {
            if pi < 0 || text[text.index(text.startIndex, offsetBy: ti)] == pattern[pattern.index(pattern.startIndex, offsetBy: pi)] {
                ti += 1
                pi += 1
            }else {
                pi = next[pi]
            }
        }
        
        return pi == plen ? ti - pi : -1
    }
    
    static func next(pattern: String) -> [Int] {
        
        let len = pattern.count
        var next = [Int].init(repeating: 0, count: len)
        next[0] = -1
        var i = 0
        var n = -1
        var imax = len - 1
        while i < imax {
            if n < 0 || pattern[pattern.index(pattern.startIndex, offsetBy: i)] == pattern[pattern.index(pattern.startIndex, offsetBy: n)] {
                i += 1
                n += 1
                if pattern[pattern.index(pattern.startIndex, offsetBy: i)] == pattern[pattern.index(pattern.startIndex, offsetBy: n)] {
                    next[i] = next[n]
                }else {
                    next[i] = n
                }
            }else {
                n = next[n]
            }
        }
        return next
    }
    
    static func next1(pattern: String) -> [Int] {
        
        let len = pattern.count
        var next = [Int].init(repeating: 0, count: len)
        next[0] = -1
        var i = 0
        var n = -1
        var imax = len - 1
        while i < imax {
            if n < 0 || pattern[pattern.index(pattern.startIndex, offsetBy: i)] == pattern[pattern.index(pattern.startIndex, offsetBy: n)] {
                i += 1
                n += 1
                next[i] = n
            }else {
                n = next[n]
            }
        }
        return next
    }
}


