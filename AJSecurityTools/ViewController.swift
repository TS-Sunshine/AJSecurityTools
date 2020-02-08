//
//  ViewController.swift
//  AJSecurityTools
//
//  Created by 安静的为你歌唱 on 2020/1/11.
//  Copyright © 2020 安静的为你歌唱. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let s = SecurityTools.shareInstance
        s.isBiometricsOpened()
        s.evaluatePolicy(localizedReason: "22", fallbackTitle: "333", SuccesResult: { (success) in
            
        }, FailureResult: { (error) in
            
        }) { (errorPointer) in
            print(errorPointer.debugDescription)
        }
        
        print(s.isSupportFaceID())
        
    }
}

