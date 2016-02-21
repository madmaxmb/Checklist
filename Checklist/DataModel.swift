//
//  DataModel.swift
//  Checklist
//
//  Created by Максим on 21.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init(){
        loadChecklists()
        resignDefault()
        handleFirstTime()
    }
    
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                
                unarchiver.finishDecoding()
            }
        }
    }
    
    func resignDefault() {
        let dictionary = ["ChecklistIndex":-1, "FirstTime": true]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            lists.append(Checklist(name: "To-Do List"))
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
}
