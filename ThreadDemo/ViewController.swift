//
//  ViewController.swift
//  ThreadDemo
//
//  Created by Monsoir on 6/13/19.
//  Copyright © 2019 monsoir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var shouldKeepRunning = false
    private var aliveThreadRunloop: RunLoop?
    private var aliveThreadRunloopPort: NSMachPort?
    private var aliveThread: Thread?
    
    private var disposableThread: Thread?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Alive Thread"
    }

    @IBAction func handleInitAliveThread(_ sender: Any) {
        guard aliveThread == nil else { return }
        
        let t = Thread(target: self, selector: #selector(asyncRun), object: nil)
        t.name = "alive"
        t.start()
        aliveThread = t
    }
    
    @IBAction func handleInitDisposableThread(_ sender: Any) {
        guard disposableThread == nil else { return }
        
        let t = Thread(target: self, selector: #selector(disposableRun), object: nil)
        t.name = "disposable"
        t.start()
        disposableThread = t
    }
    
    @IBAction func handleAliveThread(_ sender: Any) {
        guard let aliveThread = aliveThread else { return }
        
        print("Is \(aliveThread.name ?? "unknown") finished? \(aliveThread.isFinished)")
        perform(#selector(printSomethingOnAliveThread), on: aliveThread, with: nil, waitUntilDone: false)
    }
    
    @IBAction func handleDisposableThread(_ sender: Any) {
        guard let disposableThread = disposableThread else { return }
        
        print("Is \(disposableThread.name ?? "unknown") finished? \(disposableThread.isFinished)")
        perform(#selector(printSomethingOnDisposableThread), on: disposableThread, with: nil, waitUntilDone: false)
    }
    
    @IBAction func handleStopAliveThread(_ sender: Any) {
        guard let aliveThread = aliveThread else { return }
        perform(#selector(asyncStop), on: aliveThread, with: nil, waitUntilDone: false)
    }
    
    @objc private func asyncRun() {
        autoreleasepool { () -> Void in
            guard let aliveThread = aliveThread else { return }
            
            print("hello, can you here me, \(Thread.current.name ?? "unknown") thread")
            
            aliveThreadRunloop = RunLoop.current

            aliveThreadRunloopPort = NSMachPort()
            aliveThreadRunloop?.add(aliveThreadRunloopPort!, forMode: .common)
            
            shouldKeepRunning = true
//            while true {}
            while shouldKeepRunning && aliveThreadRunloop!.run(mode: .default, before: Date.distantFuture) {}
            
            if Thread.current != aliveThread {
                fatalError("Current thread is \(String(describing: aliveThread.name))")
            }

            // 移除 port
            if let runloopPort = aliveThreadRunloopPort {
                aliveThreadRunloop?.remove(runloopPort, forMode: .common)
            }

            // 移除 RunLoop
            if let runloop = aliveThreadRunloop {
                CFRunLoopStop(runloop.getCFRunLoop())
            }
            
            if !aliveThread.isCancelled {
                aliveThread.cancel()
            }
        }
    }
    
    @objc private func disposableRun() {
        print("hello, can you here me, \(Thread.current.name ?? "unknown") thread")
    }
    
    @objc private func asyncStop() {
        shouldKeepRunning = false
    }
    
    @objc private func printSomethingOnAliveThread() {
        print("=======> hey there, \(Thread.current.name ?? "unknown") thread here")
    }
    
    @objc private func printSomethingOnDisposableThread() {
        print("=======> hey there, \(Thread.current.name ?? "unknown") thread")
    }
}


