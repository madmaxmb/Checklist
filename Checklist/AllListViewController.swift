//
//  AllListViewController.swift
//  Checklist
//
//  Created by Максим on 20.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        // UIKit automatically calls this method after (после)  the view controller has become visible and the animation has completed.
        // после того как view стал видимым и прекаратилась анимация
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // when the view is about to become visible but the animation hasn’t started yet.
        // данный мето вызывается перед viewDidAppear и когда view знает что станет видимым, 
        // но отрисовки на экран еще не происходит
        super.viewWillAppear(animated)
        tableView.reloadData() // обновляет данные в таблице. 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName) // все поптому что стиль ячейки .Subtitle имеет imageView
        cell.detailTextLabel!.text = getSubtitle(checklist.countUncheckedItems(), forChecklist: checklist)
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // этот делегат прадназначен для создания обработчиков(действий) для изменения строки с индексом indexPath
        // следующим образом создаются действия:
        
        let moreAction = UITableViewRowAction(style: .Default, title: "Edit") {
            action, indexPath in
            let checklist = self.dataModel.lists[indexPath.row]
            let navigatorController =  self.storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigatorController") as! UINavigationController
            let controller = navigatorController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = checklist
            self.presentViewController(navigatorController, animated: true, completion: nil)
        }
        moreAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {
        action, indexPath in
            self.dataModel.lists.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        })
        
        return [deleteAction, moreAction]
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigatorController =  storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigatorController") as! UINavigationController
        let controller = navigatorController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        controller.checklistToEdit = dataModel.lists[indexPath.row]
        presentViewController(navigatorController, animated: true, completion: nil)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigatorControler = segue.destinationViewController as! UINavigationController
            let controller = navigatorControler.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }

    func cellForTableView(tableView: UITableView) -> UITableViewCell{
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier){
            return cell
        } else {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
            // .Defaul
        }
    }
    
    private func getSubtitle(uncheckedItems: Int, forChecklist checklist: Checklist) -> String{
        if uncheckedItems > 0 {
            return "(\(uncheckedItems) Remaining)"
        } else {
            if checklist.items.count > 0 {
                return "All Done!"
            } else {
                return "(No Items)"
            }
        }
    }
}

extension AllListViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AllListViewController: UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        //This method is called whenever the navigation controller will slide to a new screen.
        
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}

