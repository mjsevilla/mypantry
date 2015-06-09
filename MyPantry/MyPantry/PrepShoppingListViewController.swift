//
//  PrepShoppingListViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit
import CoreData

class PrepShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PrepShoppingListItemsViewControllerDelegate {
    @IBOutlet weak var prepTable: UITableView!
    var categories = [NSManagedObject]()
    var numSelectedItems = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepTable.dataSource = self
        prepTable.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchCategories()
        self.prepTable.reloadData()
    }

    @IBAction func goShop(sender: AnyObject) {
        
    }
    
    func prepShoppingListItemsVCDidFinish(controller: PrepShoppingListItemsViewController, count: Int) {
        numSelectedItems = count
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    // fetch categories from core data
    func fetchCategories() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest(entityName:"Category")
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            categories = results
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrepCell") as! PrepCell
        let category = categories[indexPath.row]
        
        cell.textLabel!.text = category.valueForKey("name") as? String
        cell.category = category
        if numSelectedItems == 1 {
            cell.detailTextLabel!.text = "1 item selected"
        }
        else {
            cell.detailTextLabel!.text = "\(numSelectedItems) items selected"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PrepCell
        
        performSegueWithIdentifier("presentShoppingItems", sender: cell)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentShoppingItems" {
            if let destVC = segue.destinationViewController as? PrepShoppingListItemsViewController {
                destVC.category = (sender as! PrepCell).category
                destVC.delegate = self
            }
        }
        else if segue.identifier == "presentShoppingList" {
            if let destVC = segue.destinationViewController as? ShoppingListViewController {
                
            }
        }
    }
}

// wrapper class to carry over a category between views
class PrepCell: UITableViewCell {
    var category: NSManagedObject?
}
