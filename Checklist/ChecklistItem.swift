//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    internal var text: String = ""
    var isChecked = false
    
    required init?(coder aDecoder:NSCoder){
        text = aDecoder.decodeObjectForKey("Text") as! String
        isChecked = aDecoder.decodeBoolForKey("isChecked")
        super.init()
    }
    override init() {
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
        aCoder.encodeBool(isChecked, forKey: "isChecked")
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
}