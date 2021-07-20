//
//  EventsTableView.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import SnapKit
import UIKit

protocol IEventsTableView: UIView {
    var parentVC: IEventsController! { get set }
    var tableView: UITableView { get set }
    var searchBar: UISearchBar { get set }
    var navbar: UINavigationBar { get set }
    func showAnimation()
    func hideAnimation() 
}

class EventsTableView: UIView, IEventsTableView {
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var parentVC: IEventsController!
    
    var navbar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.isTranslucent = false
        bar.tintColor = Color.background
        bar.backgroundColor = Color.background
        
        let navItem = UINavigationItem()
       
        let binButton = UIButton(frame: Padding.navbarButtonFrame)
        binButton.setImage(Assets.bin, for: .normal)
        binButton.addTarget(self, action: #selector(bin), for: .touchUpInside)
        
        let refreshButton = UIButton(frame: Padding.navbarButtonFrame)
        refreshButton.setImage(Assets.reload, for: .normal)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        
        let segmentedControl = UISegmentedControl(items: ["Spams", "All"])
        segmentedControl.setOldLayout(tintColor: Color.accentColor, backgroundColor: Color.inactiveColor)
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let greyColor = #colorLiteral(red: 0.5568627451, green: 0.6039215686, blue: 0.6549019608, alpha: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: font]
        let unselectedAttrs = [NSAttributedString.Key.foregroundColor: greyColor,
                               NSAttributedString.Key.font: font]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(unselectedAttrs, for: .normal)
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlValueChanged(_:)),
                                   for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0 
        
        
        navItem.titleView = segmentedControl
        navItem.setRightBarButtonItems([ UIBarButtonItem(customView: refreshButton), UIBarButtonItem(customView: binButton)], animated: true)
        
        bar.setItems([navItem], animated: true)
        return bar
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Color.inactiveColor
        return view
    }()
    
    var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.isTranslucent = true
        bar.placeholder = "Please input keyword"
        bar.textField?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bar.textField?.textColor = Color.menu
        bar.textField?.backgroundColor = .clear
        bar.backgroundColor = .clear
        bar.borderWidth = 0
        return bar
    }()
    
    
    
    private let bottomContainer = UIView()
    
    private let bottomButton: UIButton = {
        let button = UIButton()
        //fucking magic (if you wanna set title with button.setTitle, underline won't be added)
        button.setAttributedTitle(NSAttributedString(string: "Cleanup stubborn spam ads..."),
                                  for: .normal)
        button.setTitleColor(Color.accentColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let underline = UIView(frame: CGRect(x: 0, y: ((button.titleLabel?.bounds.height)!), width: (button.titleLabel?.bounds.width)!, height: 1))
        underline.backgroundColor = Color.accentColor
        button.titleLabel?.addSubview(underline)
        button.addTarget(self, action: #selector(cleanup), for: .touchUpInside)
        return button
    }()
    
    private let promptLogo: UILabel = {
        let logo = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 100, height: 50))
        logo.text = "No spam events found"
        logo.textColor = Color.accentColor
        logo.numberOfLines = 1
        return logo
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func cleanup() {
        parentVC.cleanupTapped()
    }
    
    @objc func bin() {
        parentVC.deleteTapped()
    }
    
    @objc func refresh() {
        parentVC.refreshTapped()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            parentVC.selectAnotherEventType(eventType: .spam)
        } else {
            parentVC.selectAnotherEventType(eventType: .all)
        }
    }
    
    func showAnimation() {
        promptLogo.isHidden = false
        UIHelper.createAnimation(onView: promptLogo)
    }
    
    func hideAnimation() {
        promptLogo.isHidden = true
    }
    
    
    private func configure() {
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .yes
        addSubview(navbar)
        addSubview(containerView)
        containerView.addSubview(searchContainer)
        searchContainer.addSubview(searchBar)
        containerView.addSubview(tableView)
        containerView.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomButton)
        
        layoutNavbar()
        layoutContainer()
        layoutSearchContainer()
        layoutSearchbar()
        layoutBottomContainer()
        layoutBottomButton()
        layoutTableview()
        layoutPrompt()
        
        setupTable()
    }
    
    private func layoutNavbar() {
        navbar.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(Padding.statusBarHeight)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(Padding.navbarHeight)
        }
    }
    
    private func layoutContainer() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(Padding.statusBarHeight + Padding.navbarHeight + Padding.contentOffset)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func layoutSearchContainer() {
        searchContainer.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(Padding.contentOffset)
            make.leading.equalTo(containerView.snp.leading).offset(Padding.side)
            make.trailing.equalTo(containerView.snp.trailing).offset(-Padding.side)
            make.height.equalTo(Padding.tableRowHeight)
        }
        searchContainer.layer.cornerRadius = Padding.cornerRadius
    }
    
    private func layoutSearchbar() {
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutBottomContainer() {
        bottomContainer.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
            make.height.equalTo(Padding.containerHeight)
        }
    }
    
    private func layoutBottomButton() {
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalTo(bottomContainer.snp.centerX)
            make.centerY.equalTo(bottomContainer.snp.centerY)
        }
    }
    
    private func layoutTableview() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchContainer.snp.bottom).offset(Padding.contentOffset)
            make.leading.equalTo(searchContainer.snp.leading)
            make.trailing.equalTo(searchContainer.snp.trailing)
            make.bottom.equalTo(bottomContainer.snp.top)
        }
    }
    
    private func layoutPrompt() {
        containerView.addSubview(promptLogo)
        promptLogo.snp.makeConstraints { make in
            make.centerX.equalTo(containerView.snp.centerX)
            make.centerY.equalTo(containerView.snp.centerY)
            make.width.equalTo(Padding.promptWidth)
            make.height.equalTo(Padding.promptHeight)
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


extension UISegmentedControl {
    func setOldLayout(tintColor: UIColor, backgroundColor: UIColor) {
        if #available(iOS 13, *) {
            
            let bg = UIImage(color: backgroundColor, size: CGSize(width: 1, height: 32))
            let selected = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))
            
             self.setBackgroundImage(bg, for: .normal, barMetrics: .default)
             self.setBackgroundImage(selected, for: .selected, barMetrics: .default)

        } else {
            self.tintColor = tintColor
        }
    }
}


extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(data: image.pngData()!)!
    }
}
