//
//  ExceptionViewController.swift
//  ThreadDemo
//
//  Created by Monsoir on 6/13/19.
//  Copyright © 2019 monsoir. All rights reserved.
//

import UIKit

class ExceptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleRaiseUnhandleException(_ sender: Any) {
        let aSelector = Selector("test")
        perform(aSelector)
    }
    
    @IBAction func handleRaiseExcBadAccessException(_ sender: Any) {
    }
    
}

var shouldKeepGoing = true
struct ExceptionHandler {
    func handleException(_ exception: NSException) {
        saveCriticalData()
        
        let alert = UIAlertController(title: "Oops", message: "something wrong", preferredStyle: .alert)
        let actionContinue = UIAlertAction(title: "Continue", style: .cancel) { (_) in
        }
        let actionCrash = UIAlertAction(title: "Let it crash", style: .destructive) { (_) in
            shouldKeepGoing = false
        }
        alert.addAction(actionContinue)
        alert.addAction(actionCrash)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        let runloop = CFRunLoopGetCurrent()
        guard let allModesO = CFRunLoopCopyAllModes(runloop) as [AnyObject]? else { return }
        guard let allModes = allModesO as? [CFString] else { return }
        while shouldKeepGoing {
            for mode in allModes {
                CFRunLoopRunInMode(CFRunLoopMode(mode), 0.001, false)
            }
        }
    }
    
    private func saveCriticalData() {}
}

func setupUncaughtExceptionHandler() {
    NSSetUncaughtExceptionHandler { (exception) in
        ExceptionHandler().handleException(exception)
    }
}
