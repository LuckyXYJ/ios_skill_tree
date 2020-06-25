//
//  ArrayPrint.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/19.
//

import Foundation

class ArrayPrint {
    static func printArr(arr: [Int]) -> Void {
        var str = "{"
        for i in 0..<arr.count {
            if i == arr.count - 1 {
                str = str + "\(arr[i])"
            }else {
                str = str + "\(arr[i])" + ", "
            }
        }
        str += "}"
        print(str)
    }
}
