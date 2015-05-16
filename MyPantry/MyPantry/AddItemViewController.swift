//
//  AddItemViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/15/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UIViewController {
    var barcodeVal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("======AddItemViewController======")
        println("Success! You have scanned in an item. Here is where we would display the item's information before allowing the user to select which category to add said item into.")
    }
    
    @IBAction func addItemToCategory(sender: AnyObject) {
        println("You have reviewed the item and selected which category you wish to add this item to.")
    }
}