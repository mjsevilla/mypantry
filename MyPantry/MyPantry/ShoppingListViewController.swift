//
//  ShoppingListViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/15/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("======ShoppingListViewController======")
        println("This view controller displays the user's desired shopping list for that shopping trip.")
        println("Here the user will be able to cross of items as they physically purchase them.")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCell") as! UITableViewCell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}