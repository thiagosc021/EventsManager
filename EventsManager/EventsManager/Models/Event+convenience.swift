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
    
    func getEventDay() -> String {
        let now = Date()
                
        guard let startOfWeek = now.startOfWeek,
              let endOfWeek = now.endOfWeek,
              let eventDate = self.date else {
            return ""
        }
        
        guard !Calendar.current.isDateInToday(eventDate) else {
            return "Today"
        }
        
        let currentWeek = startOfWeek...endOfWeek
        
        let dateFormatter = currentWeek.contains(eventDate) ? dayNameFormatter() : regularDateFormatter()
        return dateFormatter.string(from: self.date ?? Date())
    }
}

private extension Event {
    func dayNameFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "EE"
        return dateFormatter
    }
    
    func regularDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter
    }
}

