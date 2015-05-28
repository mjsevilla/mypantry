//
//  PantryListViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class PantryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var categoryTable: UITableView!
    var categories: [Category]?
    var categoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        println("======PantryListViewController======")
//        println("This view displays all the user's personal shopping categories.")
//        println("Here, the user can add/delete new categories for their shopping items.")
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categories = []
        categories?.sort({ $0.name < $1.name })
    }
    
    @IBAction func addCategory(sender: AnyObject) {
//        println("You clicked on a user's category.")
//        println("This button takes you to add a category to your pantry")
        let addAlert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .Alert)
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelAddCategory))
        addAlert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (UIAlertAction) in
            println("Added category: \(self.categoryTextField.text)")
            let newCat = Category(name: self.categoryTextField.text)
            self.categories?.append(newCat)
            self.categories?.sort({ $0.name < $1.name })
            self.categoryTable.reloadData()
        }))
        addAlert.addTextFieldWithConfigurationHandler(configTextField)
        self.presentViewController(addAlert, animated: true, completion: nil)
    }
    
    func configTextField(textField: UITextField!) {
//        println("generating the TextField")
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
        
        cell.textLabel?.text = categories![indexPath.row].name
        cell.category = categories![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = categoryTable.cellForRowAtIndexPath(indexPath) as! CategoryCell
//        println("You have clicked on the '\(cell.category?.name)' category.")
//        println("This is will take you to a view of all the items within that category.")
//        println("From there, you can add/delete/edit new and existing items.")
        performSegueWithIdentifier("presentCategory", sender: cell)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            categories?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
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
    var category: Category?
}
