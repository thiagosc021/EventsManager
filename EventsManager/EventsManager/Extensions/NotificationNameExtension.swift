//
//  NotificationNameExtension.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/15/22.
//

import Foundation

extension NSNotification.Name {
    static let eventDidAdd = Notification.Name("eventDidAdd")
    static let eventDidChange = Notification.Name("eventDidChange")    
    static let eventDidDelete = Notification.Name("eventDidDelete")
}

enum NotificationKeys: String {
    case eventId
}
