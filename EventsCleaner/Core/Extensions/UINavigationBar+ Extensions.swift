//
//  UINavigationBar+ Extensions.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 01.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setAttributedTitle(title: String?) {
        let titleLabel = UILabel()
        let colour = UIColor(red: 0.133, green: 0.161, blue: 0.235, alpha: 1)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                          NSAttributedString.Key.foregroundColor: colour]
        titleLabel.attributedText = NSAttributedString(string: title ?? "", attributes: attributes)
        titleLabel.sizeToFit()
        self.topItem?.titleView = titleLabel
    }
    
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0.855, green: 0.91, blue: 0.973, alpha: 1).cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 4
        self.layer.borderWidth = 0
        self.backgroundColor = .clear
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                            y: self.bounds.maxY - self.layer.shadowRadius,
                                                            width: self.bounds.width,
                                                            height: self.layer.shadowRadius)).cgPath
    }
}
