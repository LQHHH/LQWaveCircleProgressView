//
//  ViewController.swift
//  TestDemo_Swift
//
//  Created by hongzhiqiang on 2018/10/23.
//  Copyright © 2018 hhh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.progressView)
        self.progressView.startLoadView()
        
        //模拟进度
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
            time.fire()
         
        }
    }
    
    @objc func onTimer() {
        if self.progressView.progress > 1.0 {
            return
        }
        self.progressView.progress += 0.1
    }
    
    lazy var progressView: LQWaveCircleProgressView = {
        let progressView = LQWaveCircleProgressView()
        progressView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        progressView.center = self.view.center
        return progressView
    }()

}

