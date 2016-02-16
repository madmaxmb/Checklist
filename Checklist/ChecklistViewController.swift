//
//  ViewController.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    private var items = [ChecklistItem]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        items.append(ChecklistItem(text: "Walk with dog"))
        items.append(ChecklistItem(text: "Brush my teeth", withCheckedOption: true))
        items.append(ChecklistItem(text: "Learn iOS development"))
        items.append(ChecklistItem(text: "Soccer practice", withCheckedOption: true))
        items.append(ChecklistItem(text: "Eat ice cream"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItem() {
        let newRowItem = items.count
        items.append(ChecklistItem(text: "This is new item"))
        
        let indexPath = NSIndexPath(forRow: newRowItem, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
       
        let item = items[indexPath.row]
        label.text = item.getText()
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // This method automaticaly enable swipe-to-delete
    
        items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }

}

