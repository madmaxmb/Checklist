//
//  ViewController.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var checklist: Checklist!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        let item = checklist.items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        // This method automaticaly enable swipe-to-delete
//    
//        checklist.items.removeAtIndex(indexPath.row)
//        
//        let indexPaths = [indexPath]
//        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // этот делегат прадназначен для создания обработчиков(действий) для изменения строки с индексом indexPath
        // следующим образом создаются действия:
        
        let moreAction = UITableViewRowAction(style: .Default, title: "Edit") {
            action, indexPath in
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            self.performSegueWithIdentifier("EditItem", sender: cell)
        }
        moreAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {
            action, indexPath in
            self.checklist.items.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        })
        
        return [deleteAction, moreAction]
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            // sender в данном случае это объект который вызвал данный переход. В нашем случае это 
            // одна из ячеек (cell) в которой была нажата кнопка 
            // зная кто вызвал это событие можно найти строку в таблице для заданной ячейки следующим образом:
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    private func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        cell.textLabel!.text = item.getText()
        cell.detailTextLabel!.text = item.getDateInString()
    }
    
    private func configureCheckmarkForCell(cell:UITableViewCell, withChecklistItem item: ChecklistItem) {
        if item.isChecked {
            cell.accessoryType = .Checkmark
        }else {
            cell.accessoryType = .None
        }
    }
    
    private func appendItem(item: ChecklistItem){
        let newRowItem = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowItem, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func addItemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        appendItem(item)
        checklist.sortChecklistByDate()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    func addItemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        checklist.sortChecklistByDate()
        tableView.reloadData()
//        if let index = checklist.items.indexOf(item) {
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
//            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//                configureTextForCell(cell, withChecklistItem: item)
//            }
//        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
