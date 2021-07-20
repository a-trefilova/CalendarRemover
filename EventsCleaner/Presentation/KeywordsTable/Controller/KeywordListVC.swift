//
//  KeywordListVC.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 16.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import Alertift
import UIKit

class KeywordListVC: UIViewController {
    
    let rootView = KeywordListView(frame: .zero)
    let eventManager = EventManager()
    var datasource: [String] {
        get {
            return eventManager.spamTags
        }
        set {}
    }
    
    override func loadView() {
        self.view = rootView
        rootView.parentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavbar()
    }
    
    private func setupNavbar() {
        rootView.setGradientBackground(colorTop: #colorLiteral(red: 0.9044238329, green: 0.9482651353, blue: 1, alpha: 1), colorBottom: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), withCornerRadius: 0)
        rootView.navbar.setShadow()
        rootView.navbar.setAttributedTitle(title: "Keywords")
    }
    
    private func setupTableView() {
        rootView.tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseId)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
    
    
}

extension KeywordListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseId, for: indexPath) as! EventCell
        cell.configure(with: datasource[indexPath.row])
        return cell
    }
    
}


extension KeywordListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = UIContextualAction(style: .destructive, title: "Delete") { action, view, bool in
            self.rootView.tableView.beginUpdates()
            self.eventManager.deleteSpamTag(tag: self.datasource[indexPath.row])
            self.datasource.remove(at: indexPath.row)
            self.rootView.tableView.deleteRows(at: [indexPath], with: .fade)
            self.rootView.tableView.endUpdates()
        }
        let config = UISwipeActionsConfiguration(actions: [context])
        return config
    }
}

extension KeywordListVC: IKeywordController {
    func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func addTapped() {
        Alertift.alert(title: "Add keyword", message: nil)
            .textField { textfield in
                textfield.placeholder = "Input keyword"
            }
            .action(.cancel("Cancel"))
            .action(.default("Ok")) { action, _, textfields in
                if let tf = textfields?.first,
                   let text = tf.text,
                   text.count > 0 {
                    self.eventManager.addNewSpamTag(tag: text)
                    self.rootView.tableView.reloadData()
                }
            }
            .show(on: self)
    }
    
    
}
