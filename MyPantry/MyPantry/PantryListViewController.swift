//
//  PantryListViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit
import CoreData

class PantryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var categoryTable: UITableView!
    var categories = [NSManagedObject]()
    var categoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.delegate = self
        categoryTable.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCategories()
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
            emptyView.hidden = categories.count > 0
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    @IBAction func unwindToPantry(sender: UIStoryboardSegue) {
        
    }
    
    // add category to table view
    @IBAction func addCategory(sender: AnyObject) {
        let addAlert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .Alert)
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelAddCategory))
        addAlert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (UIAlertAction) in
            println("Added category: \(self.categoryTextField.text)")
            self.saveCategory(self.categoryTextField.text)
            self.categoryTable.reloadData()
            self.emptyView.hidden = true
        }))
        addAlert.addTextFieldWithConfigurationHandler(configTextField)
        self.presentViewController(addAlert, animated: true, completion: nil)
    }
    
    // save category to core data
    func saveCategory(name: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("Category", inManagedObjectContext: managedContext)
        let category = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        var error: NSError?
        
        category.setValue(name, forKey: "name")
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        else {
            categories.append(category)
            self.fetchCategories()
        }
    }
    
    // delete category from core data
    func deleteCategory(ndx: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        managedContext.deleteObject(categories[ndx] as NSManagedObject)
        categories.removeAtIndex(ndx)
        managedContext.save(nil)
        if categories.count == 0 {
            emptyView.hidden = false
        }
    }
    
    func configTextField(textField: UITextField!) {
        textField.placeholder = "ie. Dairy, Veggies, etc."
        textField.autocapitalizationType = .Words
        textField.autocorrectionType = .Default
        categoryTextField = textField
    }
    
    func cancelAddCategory(alertView: UIAlertAction!) {
        println("Cancelled adding category!")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        let category = categories[indexPath.row]
        
        cell.textLabel!.text = category.valueForKey("name") as? String
        cell.category = category
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = categoryTable.cellForRowAtIndexPath(indexPath) as! CategoryCell
        
        performSegueWithIdentifier("presentCategory", sender: cell)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteCategory(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentCategory" {
            if let destVC = segue.destinationViewController as? CategoryViewController {
                let cell = sender as! CategoryCell
                destVC.category = cell.category
            }
        }
    }
}

// wrapper class to carry over a category between views
class CategoryCell: UITableViewCell {
    var category: NSManagedObject?
}
