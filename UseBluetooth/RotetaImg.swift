//
//  RotetaView.swift
//  UseBluetooth
//
//  Created by 覃子轩 on 2017/7/3.
//  Copyright © 2017年 覃子轩. All rights reserved.
//


import UIKit

class RotetaImg:UIImageView {
    
    init(frame: CGRect,_ imgName:String) {
        super.init(frame: frame)
        
        self.image = UIImage.init(named: imgName)
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 3
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        
        // 3.将动画添加到layer中
        self.layer.add(rotationAnim, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
