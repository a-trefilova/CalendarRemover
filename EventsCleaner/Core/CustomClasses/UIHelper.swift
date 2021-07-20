//
//  UIHelper.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 19.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import UIKit

class UIHelper {
    static func createHeaderLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }
    
    static func createAnimation(onView view: UIView) /*-> CAAnimationGroup*/ {
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.addSubview(circle)
        circle.layer.cornerRadius = circle.bounds.height / 2
        circle.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let startPoint = CGRect(x: 150, y: 10, width: 20, height: 20)
        let middlePoint = CGRect(x: 50, y: 100, width: 20, height: 20)
        let finalPoint = CGRect(x: -20, y: -20, width: 20, height: 20)
        
        let upDown = CAKeyframeAnimation(keyPath: ("position"))
        upDown.values = [ middlePoint, finalPoint, startPoint, middlePoint]
        upDown.keyTimes = [0.0, 0.35, 0.65, 1.0]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0.0, 1.0, 0.0, 1.0, 0.0, 1.0]
        opacity.keyTimes = [ 0.0, 0.34, 0.37, 0.64, 0.67, 0.99]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.repeatCount = .infinity
        animationGroup.autoreverses = false
        animationGroup.duration = 3.0
        animationGroup.animations = [upDown, opacity]
        animationGroup.fillMode = .backwards
        circle.layer.add(animationGroup, forKey: "bounce")

    }
}
