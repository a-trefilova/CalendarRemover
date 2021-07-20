//
//  CalendarInstructionView.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 16.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import SnapKit
import UIKit

class CalendarInstructionView: UIView {
    
    static let attributedRanges = [CalendarInstruction.first.rawValue: NSRange(location: 14, length: 10),
                                    CalendarInstruction.third.rawValue: NSRange(location: 5, length: 11)]

    let navbar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.isTranslucent = false
        bar.tintColor = Color.background
        bar.backgroundColor = Color.background
        
        let navItem = UINavigationItem()
       
        let backButton = UIButton(frame: Padding.navbarButtonFrame)
        backButton.setImage(Assets.back, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        bar.setAttributedTitle(title: "Clean up stubborn spam")
        
        navItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: true)
        bar.setItems([navItem], animated: true)
        return bar
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let imageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "cleanupInstructionImage"))
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    let bulletedList = ECBulletedList(values: [CalendarInstruction.first.rawValue,
                                               CalendarInstruction.second.rawValue,
                                               CalendarInstruction.third.rawValue],
                                      style: .roundedPoint(font: UIFont.systemFont(ofSize: 15, weight: .medium),
                                                           color: Color.menu,
                                                           attributedRanges: attributedRanges))
    
    var backAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.background
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func back() {
        backAction?()
    }
    
    private func configure() {
        layoutNavbar()
        layoutContainer()
        layoutImage()
        layoutBulletedList()
    }
    
    private func layoutNavbar() {
        addSubview(navbar)
        navbar.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(Padding.statusBarHeight)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(Padding.navbarHeight)
        }
    }
    
    private func layoutContainer() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(Padding.statusBarHeight + Padding.navbarHeight + Padding.contentOffset)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func layoutImage() {
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(Padding.side)
            make.leading.equalTo(containerView.snp.leading).offset(Padding.side)
            make.trailing.equalTo(containerView.snp.trailing).offset(-Padding.side)
            make.bottom.equalTo(containerView.snp.centerY).offset(-Padding.side)
        }
    }
    
    private func layoutBulletedList() {
        containerView.addSubview(bulletedList)
        bulletedList.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(containerView.snp.leading).offset(Padding.side)
            make.trailing.equalTo(containerView.snp.trailing).offset(-Padding.side)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Padding.side)
        }
    }
    
}
