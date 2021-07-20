//
//  Paddings.swift
//  EventsCleaner
//
//  Created by Alyona Sabitskaya  on 20.07.2021.
//

import UIKit

struct Padding {
    static let navbarButtonFrame = CGRect(x: 0, y: 0, width: 28, height: 28)
    static let separatorInsets   = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    static dynamic var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 50
        return height
    }
    
    static let navbarHeight: CGFloat    = 44
    static let contentOffset: CGFloat   = 15
    static let side: CGFloat            = 27
    static let tableRowHeight: CGFloat  = 50
    static let promptWidth: CGFloat     = 130
    static let promptHeight: CGFloat    = 80
    static let containerHeight: CGFloat = 70
    static let cornerRadius: CGFloat    = 10
    static let smallSide: CGFloat       = 5
    static let inside: CGFloat          = 10
    static let borderWidth: CGFloat     = 1
}
