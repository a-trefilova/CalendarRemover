//
//  UserDefaults.swift
//  EventsCleaner
//
//  Created by Alyona Sabitskaya  on 19.07.2021.
//

import Foundation

class ECUserDefaults {
    private init() {}
    private enum Key: String {
        case spamTags = "spamTags"
    }
    static let shared = ECUserDefaults()
    
    private var defautSpamTags = ["Betting", "Gambling", "Invoice", "Financial", "Loan", "Cosmetic", "Purchasing", "Slot Machine"]
    
    var spamTags: [String] {
        get {
            if UserDefaults.standard.object(forKey: Key.spamTags.rawValue) == nil || UserDefaults.standard.stringArray(forKey: Key.spamTags.rawValue)!.isEmpty {
                UserDefaults.standard.setValue(defautSpamTags, forKey: Key.spamTags.rawValue)
            }
            return UserDefaults.standard.stringArray(forKey: Key.spamTags.rawValue) ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Key.spamTags.rawValue)
        }
    }
    
    
    
}
