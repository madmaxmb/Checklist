//
//  ItemDetailViewController.swift
//  Checklist
//
//  Created by Максим on 18.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func addItemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func addItemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func addItemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLable: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var datePickerVisible = false
    
    var dueDate: NSDate?
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidAppear(animated: Bool) {
        // эта функция вызывается сразу перед появлением содержимого
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.getText()
            barButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLable()
        
        let tapAnyWhere = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        tapAnyWhere.cancelsTouchesInView = false // позволит обрабатывать дальнейшие события
        view.addGestureRecognizer(tapAnyWhere) // не знаю почему, но при использовании self ни чего не работает. 
    }
    
    @IBAction func cancel() {
        delegate?.addItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.setText(newText: textField.text!)
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem(text: textField.text!)
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    @IBAction func dateChange(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLable()
    }
    
    @IBAction func shouldRemindToggled(switchControll: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControll.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerVisible {
                hideDatePicker()
            } else {
                showDataPicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else  {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // в этот метод передаются дипазон в которм изменился текст и на что он изменился
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        barButton.enabled = (newText.length > 0)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        // этот метод необходимо определить потому что data source ни чего не хнает о этой ячейке
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func updateDueDateLable() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        if let date = dueDate {
            dueDateLable.text = formatter.stringFromDate(date)
        } else {
            dueDateLable.text = formatter.stringFromDate(NSDate())
        }
    }
    func showDataPicker() {
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatPicker = NSIndexPath(forRow: 2, inSection: 1)
        // все это просто что бы изменить цвет. те просто меняем ячейку на такую же только с другим цветом.
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) { // установка цвета текста
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        tableView.beginUpdates()
        
        tableView.insertRowsAtIndexPaths([indexPathDatPicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        
        tableView.endUpdates()
        if let date = dueDate {
            datePicker.setDate(date, animated: false)
        } else {
            datePicker.setDate(NSDate(), animated: false)
        }
    }
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
}