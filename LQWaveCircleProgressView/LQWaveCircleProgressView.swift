//
//  LQWaveCircleProgressView.swift
//  TestDemo_Swift
//
//  Created by hongzhiqiang on 2018/10/23.
//  Copyright © 2018 hhh. All rights reserved.
//

import UIKit

class LQWaveCircleProgressView: UIView {
    
    public var progress : CGFloat = 0{
        didSet {
            if progress > 1.0 {
                return
            }
            self.creatAnimation()
        }
    }
    
    //水浪颜色,默认为浅蓝色
    public var waveColor : UIColor? {
        didSet {
            self.waveSinView.backgroundColor = waveColor
        }
    }
    
    //字体颜色,默认为白色
    public var textColor : UIColor? {
        didSet {
            self.percentL.textColor = textColor
        }
    }
    
    //字体大小,默认为系统默认大小
    public var textFont : UIFont? {
        didSet {
            self.percentL.font = textFont
        }
    }
    
    public func startLoadView() {
        self.setupView()
    }
    
    private var phase : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setupView() {
        self.addSubview(self.waveSinView)
        self.waveSinView.layer.mask = self.waveSinLayer
        let minRadius = min(self.bounds.size.width, self.bounds.size.height)
        self.layer.cornerRadius = minRadius/2
        self.layer.masksToBounds = true
        self.addSubview(self.percentL)
        
        let displayLink = CADisplayLink.init(target: self, selector: #selector(updateUI))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc private func updateUI(){
        let scale = self.bounds.size.width / 200.0
        self.phase += 5.0*scale
        self.waveSinLayer.path = self.path().cgPath
    }
    
   private func path() -> UIBezierPath{
        let path = UIBezierPath()
        let width = self.bounds.size.width
        let height = self.bounds.size.width
        var lastX = 0
        
        for x in 0...Int(width) {
            let a = 2*Double.pi/Double(width)*Double(x)*0.8+Double(self.phase)*2*Double.pi/Double(width)
            let y = Double(height)*0.05*sin(a) + Double(height)*0.05
            if x == 0 {
                path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            else{
                path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            lastX = x
            
            if self.progress < 1.0 {
                self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.waveSinLayer.position.y-self.bounds.size.height/2+CGFloat(y)/2)
            }
            else {
                self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2+CGFloat(y)/2)
            }
        }
        
        path.addLine(to: CGPoint(x: CGFloat(lastX), y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        return path
    }
    
   private func creatAnimation()  {
        let position = CGPoint(x: self.waveSinLayer.position.x, y: (1.5-self.progress)*self.bounds.size.height)
        let fromPosition = self.waveSinLayer.position
        self.waveSinLayer.position = position
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: fromPosition)
        animation.toValue = NSValue(cgPoint: position)
        animation.duration = 0.25
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        self.waveSinLayer.add(animation, forKey:nil)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.waveSinLayer.position.y-self.bounds.size.height/2)
        }) { (finished) in
            self.percentL.text = String(format: "%.f%@", arguments: [self.progress*100,"%"])
        }
    }
    
   private lazy var waveSinLayer: CAShapeLayer = {
        let waveSinLayer = CAShapeLayer()
        let scale = self.bounds.size.width / 200
        waveSinLayer.frame = CGRect(x: 0, y:self.bounds.size.height-10*scale, width: self.bounds.size.width, height: self.bounds.size.height)
        waveSinLayer.backgroundColor = UIColor.clear.cgColor
        return waveSinLayer
    }()
    
   private lazy var waveSinView: UIView = {
        let waveSinView = UIView()
        waveSinView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        waveSinView.backgroundColor = UIColor(red: 41/255.0, green: 240/255.0, blue: 253/255.0, alpha: 0.8)
        return waveSinView
    }()
    
   private lazy var percentL: UILabel = {
        let percentL = UILabel()
        percentL.textColor = .white
        percentL.backgroundColor = .clear
        percentL.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 30)
        percentL.textAlignment = .center
        percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height - 10)
        percentL.text = String(format: "%.f%@", arguments: [self.progress*100,"%"])
        return percentL
    }()
    
}
