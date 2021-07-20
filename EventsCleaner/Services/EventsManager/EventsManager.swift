//
//  EventsManager.swift
//
//  Created by Alyona Sabitskaya  on 15.07.2021.

import EventKit
import EventKitUI
import Foundation

class EventManager {
    
    var spamTags: [String] {
        return ECUserDefaults.shared.spamTags
    }
    var isAvailable: Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        return status == .authorized
    }
    
    private let eventStore = EKEventStore()
    private var allEvents = [EKEvent]()
    private var startDate: Date {
        return Calendar.current.date(byAdding: .year, value: -4, to: Date())!
    }
    private var endDate: Date {
        return Date()
    }
    
    
    init() {
        
    }
    
    func requestAccess(completion: @escaping ((Bool) -> Void )) {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func addNewSpamTag(tag: String) {
        var tags = ECUserDefaults.shared.spamTags
        if !tags.contains(tag) { tags.append(tag) }
        ECUserDefaults.shared.spamTags = tags
    }
    
    func deleteSpamTag(tag: String) {
        var tags = ECUserDefaults.shared.spamTags
        if tags.contains(tag) { tags.removeAll(where: { $0 == tag }) }
        ECUserDefaults.shared.spamTags = tags
    }
    
    func loadEvents(ofType type: EventType, completion: @escaping ([EKEvent]) -> Void) {
        let eventStore = EKEventStore()
        var localCalendars = eventStore.calendars(for: .event)
        localCalendars.append(contentsOf: eventStore.calendars(for: .reminder))
        
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: localCalendars)
        var events = eventStore.events(matching: predicate)
        allEvents = events
        
        switch type {
        case .spam:
            events = events.reduce(into: [EKEvent](), { array, event in
                for tag in spamTags {
                    let uppercasedTag = tag.uppercased()
                    let uppercasedEvent = event.title.uppercased()
                    if uppercasedEvent.contains(uppercasedTag) {
                        array.append(event)
                    }
                }
            })
        case .search(let keyWord):
            events = events.filter({ $0.title.lowercased().contains(keyWord) || $0.title.uppercased().contains(keyWord)})
        default:
            break
        }
        DispatchQueue.main.async {
            completion(events)
        }
    }
    
    func deleteAllSpamEvents() {
        _ = allEvents
            .reduce(into: [EKEvent]()) { result, event in
                for tag in spamTags {
                    if event.title.contains(tag) {
                        result.append(event)
                    }
                }
            }.map { event in
            try? eventStore.remove(event, span: .thisEvent)
            }
    }
    
    func removeEvent(eventId: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventId)
        if let removingEvent = eventToRemove {
            do {
                try eventStore.remove(removingEvent, span: .thisEvent)
            } catch {
                
            }
        }
    }
    
    func editEvent(eventId: String, completion: @escaping (EKEventEditViewController) -> Void) {
        let currentEvent = eventStore.event(withIdentifier: eventId)
        if let event = currentEvent {
            let eventController = EKEventEditViewController()
            eventController.event = event
            eventController.eventStore = eventStore
            DispatchQueue.main.async {
                completion(eventController)
            }
        }
    }
    
}

