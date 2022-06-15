//
//  Event+convinience.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/2/22.
//

import Foundation
import CoreData

extension Event {
     @discardableResult convenience init(name: String, desc: String, date: Date, rsvp: Bool, context: NSManagedObjectContext = CoreDataStack.context ) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.desc = desc
        self.date = date
        self.rsvp = rsvp
    }
    
}
