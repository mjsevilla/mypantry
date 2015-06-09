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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category!.valueForKey("name") as? String
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
//            category?.items?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! UITableViewCell
        
//        cell.textLabel?.text = category!.items![indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        performSegueWithIdentifier("presentItem", sender: cell)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        return category!.items!.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentItem" {
            
        }
    }
}