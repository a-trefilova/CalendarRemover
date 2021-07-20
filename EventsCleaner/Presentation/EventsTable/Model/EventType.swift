//
//  EventType.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 15.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//

import Foundation

enum EventType: Equatable {
    case spam
    case all
    case search(String)
}
