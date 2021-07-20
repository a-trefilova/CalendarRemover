//
//  KeywordListView.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 16.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import SnapKit
import UIKit

class KeywordListView: UIView {
    
    public var parentVC: IKeywordController!
    public let tableView = UITableView(frame: .zero, style: .grouped)
    public let navbar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.isTranslucent = false
        bar.tintColor = Color.background
        bar.backgroundColor = Color.background
        
        let navItem = UINavigationItem()
       
        let backButton = UIButton(frame: Padding.navbarButtonFrame)
        backButton.setImage(Assets.back, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let addButton = UIButton(frame: Padding.navbarButtonFrame)
        addButton.setImage(Assets.add, for: .normal)
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        bar.setAttributedTitle(title: "Keywords")
        
        navItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: true)
        navItem.setRightBarButton(UIBarButtonItem(customView: addButton), animated: true)
    
        bar.setItems([navItem], animated: true)
        return bar
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.background
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back() {parentVC.backTapped()}
    
    @objc func add() {parentVC.addTapped()}
    
    public func configure() {
        setupTable()
        layoutNavbar()
        layoutContainer()
        layoutTableview()
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
    
    private func layoutTableview() {
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.leading.equalTo(containerView.snp.leading).offset(Padding.side)
            make.trailing.equalTo(containerView.snp.trailing).offset(-Padding.side)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Padding.side)
        }
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.estimatedRowHeight = Padding.tableRowHeight
        tableView.separatorColor = Color.separator
        tableView.separatorInset = Padding.separatorInsets
    }
    
   
}
