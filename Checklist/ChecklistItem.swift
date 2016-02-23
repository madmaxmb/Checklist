//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ChecklistItem: NSObject, NSCoding {
    internal var text: String = ""
    var isChecked = false
    var dueDate: NSDate?
    var shouldRemind = false
    var itemID: Int
    
    required init?(coder aDecoder:NSCoder){
        text = aDecoder.decodeObjectForKey("Text") as! String
        isChecked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as? NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    convenience init(text: String){
        self.init()
        self.text = text
    }
    convenience init (text: String, withCheckedOption checked: Bool){
        self.init(text: text)
        self.isChecked = checked
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(isChecked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
    
    func getText() -> String {
        return text
    }
    func setText(newText text: String){
        self.text = text
    }
    func toggleChecked() {
        isChecked = !isChecked
    }
    
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            // Found an existing notofocation
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        if shouldRemind && dueDate?.compare(NSDate()) != .OrderedAscending {
          // Schedule new notification
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate // время когда прйдет уведомление 
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifictions = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        for notification in allNotifictions {
            if let number = notification.userInfo?["ItemID"] as? Int where number == itemID {
                return notification
            }
        }
        return nil
    }
    
    func getDateInString() -> String {
        if let date = dueDate {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            return formatter.stringFromDate(date)
        } else {
            return ""
        }
    }
    
    func compare(whithItem item: ChecklistItem) -> Bool {
        if let dueDateToFirst = dueDate, let dueDateToSecond = item.dueDate {
            return dueDateToFirst.compare(dueDateToSecond) == .OrderedDescending
        } else if let _ = dueDate {
            return true
        } else if let _ = item.dueDate{
            return false
        } else {
            return text.localizedStandardCompare(item.text) == .OrderedAscending
        }
    }
    
    deinit {
        if let notification = notificationForThisItem() {
            // Removing existing notification
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
}