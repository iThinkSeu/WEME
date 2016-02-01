//
//  discovery.swift
//  WEME
//
//  Created by liewli on 1/29/16.
//  Copyright © 2016 li liew. All rights reserved.
//

import UIKit

class DiscoverVC:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let rect = CGRectMake(CGRectGetMidX(view.frame)-80, CGRectGetMidY(view.frame)-80, 160, 160)
        let bubble = BubbleView(frame: rect)
        bubble.avatar.image = UIImage(named: "yz")
        view.addSubview(bubble)
    }
}

class BubbleView:UIView {
    var avatar:UIImageView!
    var radius:CGFloat = 80.0
    
    func initialize() {
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = radius
        avatar.layer.masksToBounds = true
        addSubview(avatar)
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(snp_centerX)
            make.centerY.equalTo(snp_centerY)
            make.width.height.equalTo(2*radius)
        }
        
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 6
        layer.shadowColor = UIColor.blackColor().alpha(0.9).CGColor
        
//        let bubble = CAShapeLayer()
//        bubble.frame = bounds
//        bubble.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, bounds.width, bounds.height)).CGPath
//        bubble.fillColor = UIColor.whiteColor().alpha(0.2).CGColor
//        bubble.transform = CATransform3DMakeRotation(CGFloat(-M_PI/10.0), 0, 0, 1)
//        layer.addSublayer(bubble)
        
        let b = CAShapeLayer()
        b.path = UIBezierPath(ovalInRect: CGRectMake(90, 60, 18, 24)).CGPath
        b.fillColor = UIColor.whiteColor().CGColor
        b.transform = CATransform3DMakeRotation(CGFloat(-M_PI/8.0), 0, 0, 1)
        
        layer.addSublayer(b)
        
        let bb = CAShapeLayer()
        bb.path = UIBezierPath(arcCenter: CGPointMake(20, 100), radius: 5, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true).CGPath
        bb.fillColor = UIColor.whiteColor().CGColor
        
        layer.addSublayer(bb)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}