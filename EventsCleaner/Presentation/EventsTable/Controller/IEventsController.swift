//
//  IEventsController.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//

import UIKit

protocol IEventsController: UIViewController {
    func deleteTapped()
    func refreshTapped()
    func selectAnotherEventType(eventType: EventType)
    func cleanupTapped()
}

