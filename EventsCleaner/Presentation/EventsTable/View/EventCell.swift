//
//  EventCell.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import SnapKit
import UIKit

class EventCell: UITableViewCell {
    
    static let reuseId = "EventCell"
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.text
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        eventLabel.text = ""
    }
    
    func configure(with title: String) {
        eventLabel.text = title
        layout()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func layout() {
        contentView.addSubview(eventLabel)
        eventLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Padding.smallSide)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }

}
