//
//  TagCell.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let reuseId = "TagCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = Color.accentColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(tag: String) {
        label.text = tag
        label.layer.cornerRadius = Padding.cornerRadius
        layoutLabel()
    }
    
    private func layoutLabel() {
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Padding.inside)
            make.leading.equalTo(contentView.snp.leading).offset(Padding.inside)
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Padding.inside)
        }
        contentView.layer.cornerRadius = Padding.cornerRadius
        contentView.borderColor = Color.accentColor
        contentView.borderWidth = Padding.borderWidth
    }
    
}


