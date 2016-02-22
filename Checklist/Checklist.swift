//
//  Checklist.swift
//  Checklist
//
//  Created by Максим on 20.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name: String
    var items = [ChecklistItem]()
    var iconName: String
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, withIconName: "No Icon")
    }
    
    init(name: String, withIconName iconName: String) {
        self.name = name
        self.iconName = iconName
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int {
        var uncheckedItems: Int = 0;
        for item in items where !item.isChecked{
            uncheckedItems++
        }
        return uncheckedItems
    }
}
