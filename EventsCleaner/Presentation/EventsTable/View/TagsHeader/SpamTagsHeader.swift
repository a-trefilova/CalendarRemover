//
//  SpamTagsHeader.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import SnapKit
import UIKit

class SpamTagsHeader: UITableViewHeaderFooterView {

    static let reuseId = "SpamTagsHeader"
    public var onEditTap: (() -> Void)?
    private var tags = [String]()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UIHelper.createHeaderLayout())
    private let editButton = UIButton(frame: .zero)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutCollectionView()
        layoutButton()
        setupCollectionView()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(withtags tags: [String]) {
        collectionView.performBatchUpdates {
            self.tags = tags
        } completion: { updated in
            self.collectionView.reloadData()
        }
    }
    
    
    @objc
    func edit() {
        onEditTap?()
    }
    
    private func layoutCollectionView() {
        self.contentView.addSubview(collectionView)
        let editButtonHeight = editButton.bounds.height + 40
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-editButtonHeight)
        }
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
        collectionView.collectionViewLayout = UIHelper.createHeaderLayout()
        collectionView.contentMode = .left
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func layoutButton() {
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Padding.smallSide)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Padding.contentOffset)
        }
    }
    
    private func setupButton() {
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor( Color.menu, for: .normal)
        editButton.setImage(Assets.edit, for: .normal)
        editButton.contentHorizontalAlignment = .leading
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
    }
   
}
//MARK: - UICollectionViewDatasource
extension SpamTagsHeader: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as! TagCell
        cell.configure(tag: tags[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SpamTagsHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableHeight = collectionView.bounds.height
        let padding: CGFloat = 10
        let rawHeight = (availableHeight - padding)/2
        
        let height: CGFloat = rawHeight
        let currentString = tags[indexPath.item]
        let width = currentString.width(withConstrainedHeight: height,
                                        font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 20
        return CGSize(width: width, height: height)
    }
}


extension String  {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesFontLeading, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.width)
        }
}
