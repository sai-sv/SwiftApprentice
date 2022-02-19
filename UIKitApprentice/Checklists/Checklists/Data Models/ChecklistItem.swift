//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Sergei Sai on 28.01.2022.
//

import Foundation
import UserNotifications

final class ChecklistItem: NSObject {
    var text: String = ""
    var isChecked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    /*init() {
        self.text = ""
        self.isChecked = false
    }*/
    
    init(text: String, isChecked: Bool = false, shouldRemind: Bool = false, dueDate: Date = Date()) {
        self.text = text
        self.isChecked = isChecked
        self.shouldRemind = shouldRemind
        self.dueDate = dueDate
        self.itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        self.removeNotification()
    }
}

// MARK: - Save & Load Data
extension ChecklistItem: Codable {}

// MARK: - Local Notification
extension ChecklistItem {
    
    func sheduleNotification() {
        self.removeNotification()
        guard self.shouldRemind && self.dueDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder: "
        content.body = self.text
        content.sound = .default
        
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(self.itemID)",
                                            content: content,
                                            trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
        //print("Sheduled \(request) for itemID: \(self.itemID)")
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(self.itemID)"])
    }
}
