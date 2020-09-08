//
//  DynamicProgramming.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/30.
//

import Foundation

class CoinsNumber {
    
    // 通用实现
    static func coins(n: Int, faces: [Int]) -> Int {
        if n < 1 || faces.count == 0 { return -1 }
        
        var dp = [Int].init(repeating: 0, count: n + 1)
        var res = [Int].init(repeating: 1, count: n+1)
        for i in 1...n {
            var mn = Int.max
            
            for face in faces {
                if i < face { continue }
                if dp[i - face] < 0 || dp[i - face] >= mn { continue }
                mn = dp[i - face]
                res[i] = face
            }
            
            if mn == Int.max {
                dp[i] = -1
            }else {
                dp[i] = mn + 1
            }
        }
        printResult(res, n)
        
        return dp[n]
    }
    
    static func coins3(n: Int) -> Int {
        if n < 1 { return -1 }
        
        var dp = [Int].init(repeating: 0, count: n+1)
        var faces = [Int].init(repeating: 1, count: n+1)
        for i in 1...n {
            var mn = dp[i - 1]
//            faces[i] = 1;
            if i >= 5 && dp[i - 5] < mn {
                mn = dp[i - 5]
                faces[i] = 5
            }
            if i >= 20 && dp[i - 20] < mn {
                mn = dp[i - 20]
                faces[i] = 20
            }
            if i >= 25 && dp[i - 25] < mn {
                mn = dp[i - 25]
                faces[i] = 25
            }
            dp[i] = mn + 1
        }
        printResult(faces, n)
        return dp[n]
    }
    
    static func printResult(_ faces: [Int], _ i: Int) {
        var n = i;
        while n > 0 {
            print(faces[n], terminator: " ")
            n -= faces[n]
        }
        print("")
    }
    
    // 暴力递归优化-- 记录中间值
    static func coins2(n: Int) -> Int {
        if n < 1 { return -1 }
        
        var dp = [Int].init(repeating: 0, count: n+1)
        let faces: Set = [1, 5, 20, 25]
        for face in faces {
            if n > face {
                dp[face] = 1
            }
        }
        return coinsRecursion(n: n, dp: &dp)
    }
    
    static func coinsRecursion(n: Int, dp: inout [Int]) -> Int {
        
        if n < 1 { return Int.max }
        
        if dp[n] == 0 {
            let min1 = min(coinsRecursion(n: n - 25, dp: &dp), coinsRecursion(n: n - 20, dp: &dp))
            let min2 = min(coinsRecursion(n: n - 5, dp: &dp), coinsRecursion(n: n - 1, dp: &dp))
            dp[n] = min(min1, min2) + 1
        }
        return dp[n]
    }
    
    // 暴力递归
    static func coins1(n: Int) -> Int {
        if n < 1 { return Int.max } // 不能输出0或-1，避免递归的时候影响到结果
        
        if n == 1 || n == 5 || n == 20 || n == 25 { return 1 }
        
        let min1 = min(coins1(n: n - 1), coins1(n: n - 5))
        let min2 = min(coins1(n: n - 20), coins1(n: n - 25))
        
        return min(min1, min2) + 1
    }
    
}
