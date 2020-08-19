//
//  RS_汉诺塔.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/26.
//

import Foundation
/**
  编程实现把 A 的 n 个盘子移动到 C（盘子编号是 [1, n] ）
    - 每次只能移动1个盘子
    - 大盘子只能放在小盘子下面
 */

class hanoiRecursion {
    
    static func move(i: Int, from: String, to: String) {
        print(i, "号盘子:", from, "->", to)
    }
    
    static func hanoi(n: Int, p1: String, p2: String, p3: String) {
        if n <= 1 {
            move(i: n, from: p1, to: p3)
            return
        }
        
        hanoi(n: n - 1, p1: p1, p2: p3, p3: p2)
        move(i: n, from: p1, to: p3)
        hanoi(n: n - 1, p1: p2, p2: p1, p3: p3)
    }
}
