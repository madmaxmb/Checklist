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
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidAppear(animated: Bool) {
        // эта функция вызывается сразу перед появлением содержимого
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.getText()
            barButton.enabled = true
        }
    }
    
    @IBAction func cancel() {
        delegate?.addItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.setText(newText: textField.text!)
            delegate?.addItemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem(text: textField.text!)
            delegate?.addItemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // в этот метод передаются дипазон в которм изменился текст и на что он изменился
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        barButton.enabled = (newText.length > 0)
        return true
    }
}