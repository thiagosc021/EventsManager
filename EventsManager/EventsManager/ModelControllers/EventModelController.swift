//
//  EventModelController.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/8/22.
//

import Foundation
import CoreData

class EventModelController {
    
    static let shared = EventModelController()
    
    private lazy var fetchRequest: NSFetchRequest<Event> = {
            let request = NSFetchRequest<Event>(entityName: "Event")
            request.predicate = NSPredicate(value: true)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let sortDescriptors = [sortDescriptor]
            request.sortDescriptors = sortDescriptors
            return request
        }()
    
    var rsvpList: [Event] = []
    var notRsvpList: [Event] = []
    
    func save(name: String, description: String, date: Date, rsvp: Bool, address: String) {
        let event = Event(name: name, desc: description, date: date, rsvp: rsvp, address: address)
        CoreDataStack.saveContext()
        updateList(with: event)
        NotificationCenter.default.post(name: .eventDidAdd, object: self, userInfo: nil)        
    }
    
    func update(event: Event, name: String, description: String, date: Date, rsvp: Bool) {
        event.name = name
        event.desc = description
        event.date = date
        event.rsvp = rsvp
        CoreDataStack.saveContext()
        
        removeFromList(event)
        updateList(with: event)
    
        NotificationCenter.default.post(name: .eventDidChange, object: self, userInfo: [NotificationKeys.eventId: event.id!])
    }
    
    func loadEvent(by id: UUID) -> Event? {
        if let event = rsvpList.first(where: { $0.id == id }) {
            return event
        }
        if let event = notRsvpList.first(where: { $0.id == id}) {
            return event
        }
        return nil
    }
    
    func fetch() {
        do {
            let events = try CoreDataStack.context.fetch(fetchRequest)
            rsvpList.removeAll()
            notRsvpList.removeAll()
            
            events.forEach { event in
                if event.rsvp {
                    rsvpList.append(event)
                } else {
                    notRsvpList.append(event)
                }
            }
            
        } catch {
            print("Error fetching events: \(error)")
        }
    }
}

private extension EventModelController {
    func updateList(with event: Event) {
        if event.rsvp {
            rsvpList.append(event)
            let sorted = rsvpList.sorted(by: { $0.date! > $1.date! })
            rsvpList.removeAll()
            rsvpList.append(contentsOf: sorted)
        } else {
            notRsvpList.append(event)
            let sorted = notRsvpList.sorted(by: { $0.date! > $1.date! })
            notRsvpList.removeAll()
            notRsvpList.append(contentsOf: sorted)
        }
    }
    
    func removeFromList(_ event: Event) {
        if let eventIndex = rsvpList.firstIndex(of: event) {
            rsvpList.remove(at: eventIndex)
            return
        }
        if let eventIndex = notRsvpList.firstIndex(of: event) {
            notRsvpList.remove(at: eventIndex)
            return
        }
    }
}
