//
//  RS_斐波那契数列.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/26.
//

import Foundation
// 求 1+2+3+...+(n-1)+n 的和（n>0）
/**
 时间复杂度降低O(n^2)，
 空间复杂度O(n)
 */
class fibRecursion {
    
    static func fib(_ n: Int) -> Int {
        
        if n < 3 { return 1 }
        
        return fib(n-1) + fib(n-2)
    }
}


/**
    优化 - 记忆法
    数组存放计算过的结果，避免重复计算，
    时间复杂度降低O(n)，
    空间复杂度O(n)
 */
class fibRecursion1 {
    
    static func fib(_ n: Int) -> Int {
        
        if n < 3 { return 1 }
        
        var arr = [Int].init(repeating: 0, count: n+1)
        arr[1] = 1
        arr[0] = 1
        
        return fibr(arr: &arr, n: n)
    }
    
    static func fibr(arr: inout [Int], n: Int) -> Int {
        if(arr[n] == 0) {
            arr[n] = fibr(arr: &arr, n: n - 1) + fibr(arr: &arr, n: n - 2)
        }
        
        return arr[n]
    }
}

/**
    优化 - 递归变循环
    时间复杂度降低O(n)，
    空间复杂度O(n)
 */
class fibRecursion2 {
    
    static func fib(_ n: Int) -> Int {
        
        if n < 3 { return 1 }
        
        var arr = [Int].init(repeating: 0, count: n+1)
        arr[1] = 1
        arr[0] = 1
        for i in 3..<n {
            arr[i] = arr[i-1] + arr[i-2]
        }
        return arr[n]
    }
    
}

/**
    优化
    仅用两个数据存放中间数据
    时间复杂度降低O(n)，
    空间复杂度O(1)
 */
class fibRecursion3 {
    
    static func fib(_ n: Int) -> Int {
        
        if n < 3 { return 1 }
        
        var arr = [Int].init(repeating: 0, count: 2)
        arr[1] = 1
        arr[0] = 1
        for i in 3..<n {
            arr[i%2] = arr[(i-1)%2] + arr[(i-2)%2]
        }
        return arr[n%2]
    }
}

/**
    优化- 位运算取代模运算
    仅用两个数据存放中间数据
    时间复杂度降低O(n)，
    空间复杂度O(1)
 */
class fibRecursion4 {
    
    static func fib(_ n: Int) -> Int {
        
        if n < 3 { return 1 }
        
        var arr = [Int].init(repeating: 1, count: 2)
        for i in 3..<n {
            arr[i&1] = arr[(i-1)&1] + arr[(i-2)&1]
        }
        return arr[n&1]
    }
}

/**
    优化-
    仅用两个数存放中间数据
    时间复杂度降低O(n)，
    空间复杂度O(1)
 */
class fibRecursion5 {
    
    static func fib(_ n: Int) -> Int {
        
        if n < 3 { return 1 }
        
        var left = 1
        var right = 1
        for _ in 3..<n {
            right = left + right
            left = right - left
        }
        return right
    }
}


/**
    优化- 数学计算-最为强大
    时间、空间复杂度取决于pow函数，至少低至O(logn)
 */
class fibRecursion6 {
    
    static func fib(_ n: Int) -> Int {
        
        let c = sqrt(5)
        return Int((pow((1+c)/2, Double(n)) - pow((1-c)/2, Double(n)))/c)
    }
}

