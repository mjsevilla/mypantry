//
//  PrepShoppingListItemsViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla on 6/9/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol PrepShoppingListItemsViewControllerDelegate {
    func prepShoppingListItemsVCDidFinish(controller: PrepShoppingListItemsViewController, count: Int)
}

class PrepShoppingListItemsViewController: UITableViewController {
    var delegate: PrepShoppingListItemsViewControllerDelegate? = nil
    var category: NSManagedObject?
    var items = [NSManagedObject]()
    var numSelected = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.sendDataBack(self)
    }
    
    func sendDataBack(sender: AnyObject?) {
        if self.delegate != nil {
            self.tableView.reloadData()
            self.delegate!.prepShoppingListItemsVCDidFinish(self, count: numSelected)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchItems()
        self.tableView.reloadData()
    }
    
    // fetch items from core data
    func fetchItems() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            items = results
            
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrepItemCell") as! UITableViewCell
        
        cell.textLabel?.text = items[indexPath.row].valueForKey("name") as? String
        if cell.accessoryType == .Checkmark {
            numSelected++
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell!.accessoryType == .Checkmark ? UITableViewCellAccessoryType.None : .Checkmark
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}