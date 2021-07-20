//
//  EventsTableAssembly.swift
//  EventsCleaner
//
//  Created by Alyona Sabitskaya  on 20.07.2021.
//

import UIKit

class EventsTableAssembly {
    
    func build() -> UIViewController {
        let manager = EventManager()
        let view: IEventsTableView = EventsTableView()
        let activeType: EventType = .spam
        let viewController = EventsTableVC(rootView: view,
                                           eventManager: manager,
                                           activeType: activeType)
        return viewController
    }
}
