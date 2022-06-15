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
            return request
        }()
    
    var rsvpList: [Event] = []
    var notRsvpList: [Event] = []
    
    func save(name: String, description: String, date: Date, rsvp: Bool) {
        Event(name: name, desc: description, date: date, rsvp: rsvp)
        CoreDataStack.saveContext()
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
