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

class LC_23_合并K个升序链表1 {
    
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {

        return merge(lists, 0, lists.count)
    }
    
    func merge(_ list: [ListNode?], _ left: Int, _ right: Int) -> ListNode? {
        
        if left == right {
            return list[left]
        }
        if left > right {
            return nil
        }
        
        let mid = (left + right) >> 1
        
        return mergeTwoLists(merge(list, left, mid), merge(list, mid+1, right))
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

/// 优先级队列
class LC_23_合并K个升序链表2 {
    class Solution {
        func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
          let priorityQueue = PriorityQueue<ListNode>{ ( $0.val <= $1.val )}
          for node in lists {
            guard let node = node else {
              continue
            }
            priorityQueue.push(node)
          }
        
          let head = ListNode()
          var tail = head
        
          while !priorityQueue.isEmpty {
            let element = priorityQueue.poll()!
            tail.next = element
            tail = tail.next!
            //! 如果堆顶有后继节点，则将其入堆，重新堆化
            guard let next = element.next else {
              continue
            }
            priorityQueue.push(next)
          }
          return head.next
        }
    }

    //! 自定义 堆
    typealias PriorityBlock<T> = (T, T) -> Bool
    class PriorityQueue<T> {
        var elements: [T]
        var priorityBlock: PriorityBlock<T>

        var isEmpty: Bool {
          return elements.isEmpty
        }

        var count: Int {
          return elements.count
        }
        

        init(_ block: @escaping PriorityBlock<T>) {
          elements = []
          priorityBlock = block
        }

        public func push(_ num: T) {
          elements.append(num)
          heapifyUp(count - 1)
        }

        @discardableResult
        public func poll() -> T? {
          if self.count == 0 {
            return nil
          }
          elements.swapAt(0, count - 1)
          let element = elements.removeLast()
          heapifyDown(0)
          return element
        }
      
        public func peek() -> T? {
          if self.count == 0 {
            return nil
          }
          return elements.first!
        }
        //! 新增一个元素到末尾，它需要 上溢
        private func heapifyUp(_ i: Int) {
          guard i > 0 else { return }
          let parent = (i - 1) / 2
          if priorityBlock(elements[i], elements[parent]) {
            elements.swapAt(i, parent)
            heapifyUp(parent)
          }
        }

        //! 将堆顶删除时，我们是将 堆顶和 数组末互换，再移除的，此时堆顶元素需要下沉
        private func heapifyDown(_ i: Int) {
          let left = i * 2 + 1
          let right = left + 1
          var postion = i
          if left < count && priorityBlock(elements[left], elements[postion]) {
            postion = left
          }
          if right < count && priorityBlock(elements[right], elements[postion]) {
            postion = right
          }

          if postion != i {
            elements.swapAt(i, postion)
            heapifyDown(postion)
          }
        }
    }
}
