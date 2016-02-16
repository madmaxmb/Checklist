//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation

class ChecklistItem {
    internal var text: String
    var isChecked = false
    required init(text: String){
        self.text = text
    }
    convenience init (text: String, withCheckedOption checked: Bool){
        self.init(text: text)
        self.isChecked = checked
    }
    func getText() -> String {
        return text
    }
    func toggleChecked() {
        isChecked = !isChecked
    }
}