//
//  SMBulletedList.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 19.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import SnapKit
import UIKit

class ECBulletedList: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    enum ListStyle {
        case roundedPoint(font: UIFont, color: UIColor, attributedRanges: [String: NSRange])
    }
    
    var values: [String]?
    var style: ListStyle?
    var font: UIFont?
    var color: UIColor?
    var attributedRanges: [String: NSRange]?
    
    convenience init(values: [String], style: ListStyle) {
        self.init(frame: .zero)
        self.values = values
        self.style = style
        switch style {
        case .roundedPoint(font: let font, color: let color, attributedRanges: let attributedRanges):
            self.font = font
            self.color = color
            self.attributedRanges = attributedRanges
        }
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layoutContainer()
    }
    
    private func layoutContainer() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        createStackView()
    }
    
    private func createStackView() {
        
        var arrayOfStackElements = [UIView]()
        guard let values = values, !values.isEmpty else { return }
        for string in values {
            let view = createOneElementOfList(text: string)
            arrayOfStackElements.append(view)
        }
        
        let stackView = UIStackView(arrangedSubviews: arrayOfStackElements)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createOneElementOfList(text: String) -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let bullet = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        bullet.image = Assets.bullet
        bullet.contentMode = .center
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.textAlignment = .left
        label.numberOfLines = 0
        
        if let localText = label.text,
           let ranges = attributedRanges,
           let attributedRange = ranges[text],
           attributedRange.length > 0 {
            let selectionColor = Color.accentColor
            let attribute = [NSAttributedString.Key.foregroundColor: selectionColor]
            let mutableString = NSMutableAttributedString(string: localText)
            mutableString.addAttributes(attribute, range: attributedRange)
            label.attributedText = mutableString
        }
        
        containerView.addSubview(bullet)
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(5)
            make.bottom.equalTo(containerView.snp.bottom).offset(-5)
            make.leading.equalTo(bullet.snp.trailing).offset(10)
            make.trailing.equalTo(containerView.snp.trailing).offset(-5)
        }
        
        bullet.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(5)
            make.centerY.equalTo(label.snp.centerY)
            make.height.equalTo(5)
            make.width.equalTo(5)
        }
        
        return containerView
    }
    
}
