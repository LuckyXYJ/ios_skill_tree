//
//  XZBlockMonitor.swift
//  BaseProject
//
//  Created by ios on 2021/4/15.
//  Copyright © 2021 ios. All rights reserved.
//

import Foundation
import UIKit

class XZBlockMonitor: NSObject {
    
    static let share = XZBlockMonitor.init()
    
    fileprivate var semaphore: DispatchSemaphore!
    fileprivate var timeoutCount: Int!
    fileprivate var activity: CFRunLoopActivity!
    
    private override init() {
        super.init()
    }

    
    public func start(){
        //监控两个状态
        registerObserver()
        
        //启动监控
        startMonitor()
    }
    
    private func registerObserver(){
        let controllerPointer = Unmanaged<XZBlockMonitor>.passUnretained(self).toOpaque()
        var context: CFRunLoopObserverContext = CFRunLoopObserverContext(version: 0, info: controllerPointer, retain: nil, release: nil, copyDescription: nil)
        let observer: CFRunLoopObserver = CFRunLoopObserverCreate(nil, CFRunLoopActivity.allActivities.rawValue, true, 0, { (observer, activity, info) in
            
            guard info != nil else{
                return
            }
            
            let monitor: XZBlockMonitor = Unmanaged<XZBlockMonitor>.fromOpaque(info!).takeUnretainedValue()
            monitor.activity = activity
            let sem: DispatchSemaphore = monitor.semaphore
            sem.signal()
            
        }, &context)
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
    }
    
    private func  startMonitor(){
        //创建信号
        semaphore = DispatchSemaphore(value: 0)
        //在子线程监控时长
        DispatchQueue.global().async {
            while(true){
                // 超时时间是 1 秒，没有等到信号量，st 就不等于 0， RunLoop 所有的任务
                let st = self.semaphore.wait(timeout: DispatchTime.now()+1.0)
                if st != DispatchTimeoutResult.success {
                    //监听两种状态kCFRunLoopBeforeSources 、kCFRunLoopAfterWaiting，
                    if self.activity == CFRunLoopActivity.beforeSources || self.activity == CFRunLoopActivity.afterWaiting {
                        
                        self.timeoutCount += 1
                        
                        if self.timeoutCount < 2 {
                            print("timeOutCount = \(self.timeoutCount)")
                            continue
                        }
                        // 一秒左右的衡量尺度 很大可能性连续来 避免大规模打印!
                        print("检测到超过两次连续卡顿")
                    }
                }
                self.timeoutCount = 0
            }
        }
    }
}

