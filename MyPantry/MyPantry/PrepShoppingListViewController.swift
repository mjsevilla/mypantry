//
//  PrepShoppingListViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class PrepShoppingListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("======PrepShoppingListViewController======")
        println("Here, the user will scan through all their items in each category and specify which items in particular the user will go out and buy for a given shopping trip.")
    }

    @IBAction func goShop(sender: AnyObject) {
        println("This button finalizes the shopping list and takes the user to the view of his/her selected items for that instance's shopping trip")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentShoppingList" {
            if let destVC = segue.destinationViewController as? ShoppingListViewController {
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

