//
//  SwiftSymbol.swift
//  MachOAndSymbol
//
//  Created by xyj on 2021/1/17.
//


internal enum XZSwiftEnumSymbol {
    case maxHeap
    case minHeap

    internal func comparator<T: Comparable>(type: T.Type) -> (T, T) -> Bool {
        switch self {
        case .maxHeap:
            return (>)
        case .minHeap:
            return (<)
        }
    }
}

struct XZSwiftStructSymbol {
    

    func testSwiftStructSymbol(o: Int) {
        
    }

}

public protocol XZSwiftProtocolSymbol: class {
   
    func testSwiftProtocolSymbol()

}

public class XZSwiftClassSymbol {
   
 
    func testSwiftSymbol() {
        
    }
}

