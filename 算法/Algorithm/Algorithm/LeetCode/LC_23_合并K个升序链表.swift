//
//  LC_23合并K个升序链表.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/21.
//

import Foundation

class LC_23_合并K个升序链表 {
    
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {

        var resNode:ListNode? = nil;
        
        for node in lists {
            resNode = mergeTwoLists(resNode, node);
        }
        return resNode;
    }
    
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        if list1 == nil {
            return list2
        }
        
        if list2 == nil {
            return list1
        }
        
        let resHead: ListNode? = ListNode()
        var resLast = resHead
        var oList1 = list1
        var oList2 = list2
        while oList1 !== nil && oList2 !== nil {
            if (oList1!.val < oList2!.val) {
                resLast?.next = oList1
                oList1 = oList1!.next
            }else {
                resLast?.next = oList2
                oList2 = oList2!.next
            }
            resLast = resLast?.next
        }
        
        resLast?.next = oList1 == nil ? oList2 : oList1
        
        return resHead?.next
    }
}


