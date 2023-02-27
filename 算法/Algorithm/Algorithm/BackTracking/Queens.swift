//
//  Queens.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/27.
//

import Foundation

// 每行一个皇后，所以存储每行皇后的列号
// 逐个去试
class Queens {
    // 存放每个皇后的列号
    var queues:[Int] = []
    // 一共有多少字合理的摆法
    var ways = 0

    /// 检查第row 行，第 col 列是否可以摆放 皇后
    /// - Parameters:
    ///   - row: 行
    ///   - col: 列
    /// - Returns: 是否可以摆放
    private func isValid(row: Int, col: Int) -> Bool{
        for i in 0..<row {
            if queues[i] == col { return false }
            
            if row - i == abs(col - queues[i]) { return false }
        }
        return true
    }
    
    
    public func show() {
        print("\n===================>begin")
        for row in 0..<queues.count {
            for col in 0..<queues.count {
                if queues[row] == col {
                    print(1, terminator: "  ")
                }else {
                    print(0, terminator: "  ")
                }
            }
            print("\n")
        }
        print("===================>end\n")
    }
    
    public func place(row: Int) {
        if row == queues.count {
            ways += 1;
            show();
            return
        }
        
        for col in 0..<queues.count {
            if isValid(row: row, col: col) {
                queues[row] = col
                place(row: row + 1)
            }
        }
    }
    
    public func placeQueens(count: Int) {
        if count < 1 { return }
        
        queues = [Int].init(repeating: 0, count: count)
        
        place(row: 0);
        
        print(count, "皇后一共有", ways, "种摆法")
    }
}

class Queens1 {
   
    // 一共有多少字合理的摆法
    var ways = 0
    
    // 记录每一列是否有皇后
    var cols:[Bool] = []
    // 记录左上的斜线顶点是否有皇后，左上顶点有 2*count - 1 个
    var leftTop:[Bool] = []
    // 记录右上的斜线顶点是否有皇后，左上顶点有 2*count - 1 个
    var rightTop:[Bool] = []
    
    private func isValid(col: Int, ltIndex: Int, rtIndex: Int) -> Bool{
        if cols[col] { return false  }
        if leftTop[ltIndex] { return false  }
        if rightTop[rtIndex] { return false  }
        return true
    }
    
    
    public func place(row: Int) {
        if row == cols.count {
            ways += 1;
            return
        }
        
        for col in 0..<cols.count {
            let ltIndex = row - col + cols.count - 1
            let rtIndex = row + col
            if !isValid(col: col, ltIndex: ltIndex, rtIndex: rtIndex) { continue }
            cols[col] = true; leftTop[ltIndex] = true; rightTop[rtIndex] = true
            place(row: row + 1)
            cols[col] = false; leftTop[ltIndex] = false; rightTop[rtIndex] = false
        }
    }
    
    public func placeQueens(count: Int) {
        if count < 1 { return }
        
        cols = [Bool].init(repeating: false, count: count)
        leftTop = [Bool].init(repeating: false, count: count << 1 - 1)
        rightTop = [Bool].init(repeating: false, count: count << 1 - 1)
        place(row: 0);
        print(count, "皇后一共有", ways, "种摆法")
    }
}
