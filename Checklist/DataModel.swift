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
    
    init(){
        loadChecklists()
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
    
}
