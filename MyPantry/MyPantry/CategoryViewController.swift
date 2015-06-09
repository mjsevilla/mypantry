//
//  CategoryViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/27/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var category: NSManagedObject?
    var items = [NSManagedObject]()
    var filteredItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category!.valueForKey("name") as? String
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
    
    // delete item from core data
    func deleteItem(ndx: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        managedContext.deleteObject(items[ndx] as NSManagedObject)
        items.removeAtIndex(ndx)
        managedContext.save(nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! UITableViewCell
        let price = items[indexPath.row].valueForKey("price") as? String
        let quantity = items[indexPath.row].valueForKey("quantity") as? Int
        
        cell.textLabel?.text = items[indexPath.row].valueForKey("name") as? String
        cell.detailTextLabel?.text = "Qt: \(quantity!) -> \(price!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        performSegueWithIdentifier("presentItem", sender: cell)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentItem" {
            
        }
    }
}