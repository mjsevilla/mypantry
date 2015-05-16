//
//  PantryListViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class PantryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTable: UITableView!
    var categories: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("======PantryListViewController======")
        println("This view displays all the user's personal shopping categories.")
        println("Here, the user can add/delete new categories for their shopping items.")
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categories = ["This is an example category", "Dairy", "Freezer Items"]
    }
    
    @IBAction func addCategory(sender: AnyObject) {
        println("You clicked on a user's category.")
        println("This button takes you to add a category to your pantry")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! UITableViewCell
        
        cell.textLabel?.text = categories![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = categoryTable.cellForRowAtIndexPath(indexPath)
        println("You have clicked on the '\(cell!.textLabel!.text!)' category.")
        println("This is will take you to a view of all the items within that category.")
        println("From there, you can add/delete/edit new and existing items.")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
