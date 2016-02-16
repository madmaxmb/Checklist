//
//  ViewController.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    private var rowsItem = [ChecklistItem]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rowsItem.append(ChecklistItem(text: "Walk with dog"))
        rowsItem.append(ChecklistItem(text: "Brush my teeth", withCheckedOption: true))
        rowsItem.append(ChecklistItem(text: "Learn iOS development"))
        rowsItem.append(ChecklistItem(text: "Soccer practice", withCheckedOption: true))
        rowsItem.append(ChecklistItem(text: "Eat ice cream"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsItem.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
       
        let item = rowsItem[indexPath.row]
        label.text = item.getText()
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = rowsItem[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func configureCheckmarkForCell(cell:UITableViewCell, withChecklistItem item: ChecklistItem) {
        if item.isChecked {
            cell.accessoryType = .Checkmark
        }else {
            cell.accessoryType = .None
        }
        
    }

}

