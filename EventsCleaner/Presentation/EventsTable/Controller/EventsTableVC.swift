//
//  EventsTableVC.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import Alertift
import EventKitUI
import UIKit

class EventsTableVC: UIViewController, UINavigationControllerDelegate {
    
    private let eventManager: EventManager
    private var rootView: IEventsTableView
    private var datasource: [EventViewModel]
    private var activeEventType: EventType { didSet {loadData()} }
    
    init(rootView: IEventsTableView, eventManager: EventManager, activeType: EventType) {
        self.rootView = rootView
        self.eventManager = eventManager
        self.activeEventType = activeType
        self.datasource = []
        super.init(nibName: nil, bundle: nil)
        rootView.parentVC = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupTableView()
        setupSearchBar()
        getAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavbar()
    }
    
    private func getAccess() {
        eventManager.requestAccess { granted in
            if granted {
                self.activeEventType = .spam
            } else {
                self.showPermissionDeniedAlert(on: self)
            }
        }
    }
    
    fileprivate func loadData() {
        eventManager.loadEvents(ofType: activeEventType) { [unowned self] viewmodels in
            self.datasource = viewmodels.map({ EventViewModel(eventIdentifier: $0.eventIdentifier ?? "",
                                                              eventName: $0.title ?? "")})
            self.rootView.tableView.reloadData()
            if self.datasource.isEmpty { self.rootView.showAnimation() } else { self.rootView.hideAnimation()}
        }
    }
    
    
    private func setupTableView() {
        rootView.tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseId)
        rootView.tableView.register(SpamTagsHeader.self, forHeaderFooterViewReuseIdentifier: SpamTagsHeader.reuseId)
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }
    
    
    private func setupSearchBar() {
        rootView.searchBar.delegate = self
    }
    
    private func setupNavbar() {
        rootView.setGradientBackground(colorTop: #colorLiteral(red: 0.9044238329, green: 0.9482651353, blue: 1, alpha: 1), colorBottom: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), withCornerRadius: 0)
        rootView.navbar.setShadow()
    }
    
    private func showPermissionDeniedAlert(on vc: UIViewController) {
        Alertift
            .alert(title: "Permission denied", message: "Open settings and enable access to calendar for futher cleaning")
            .action(.cancel("Cancel"))
            .action(.default("Open settings")) { _, _, _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl) { _ in }
                }
            }
            .show(on: vc)
    }
}

extension EventsTableVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SpamTagsHeader.reuseId) as! SpamTagsHeader
        view.configure(withtags: eventManager.spamTags)
        view.onEditTap = {
            let vc = KeywordListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseId, for: indexPath) as! EventCell
        let currentViewModel = datasource[indexPath.row]
        cell.configure(with: currentViewModel.eventName)
        return cell
    }
    
    
}

extension EventsTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentViewModel = datasource[indexPath.row]
        eventManager.editEvent(eventId: currentViewModel.eventIdentifier) { controller in
            controller.editViewDelegate = self
            controller.delegate = self
            self.present(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
     
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentViewModel = datasource[indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, bool in
            tableView.beginUpdates()
            self?.eventManager.removeEvent(eventId: currentViewModel.eventIdentifier)
            self?.datasource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}

extension EventsTableVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activeEventType = .search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.textField?.resignFirstResponder()
    }
}

extension EventsTableVC: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true) { self.loadData() }
    }
    
    
}

extension EventsTableVC: IEventsController {
    func deleteTapped() {
        guard activeEventType == .spam && datasource.count > 0 else { return }
        Alertift.alert(title: "Delete all spam events?", message: nil)
            .action(.cancel("Cancel"))
            .action(.destructive("Delete")) { [weak self] _, _, _ in
                self?.eventManager.deleteAllSpamEvents()
                self?.loadData()
            }
            .show(on: self)
    }
    
    func refreshTapped() {
        loadData()
    }
    
    func selectAnotherEventType(eventType: EventType) {
        self.activeEventType = eventType
    }
    
    func cleanupTapped() {
        let vc = CalendarInstructionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
