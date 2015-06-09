//
//  AddItemViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/15/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    var itemNameText = ""
    var itemPriceText = ""
    var categories = [NSManagedObject]()
    var selectedCategory: NSManagedObject!
    var categoryTextField: UITextField!
    var origPrice = ""
    var pickerData: [String] = []
    var tapGest: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCategories("")
        itemName.text = itemNameText
        itemPrice.text = itemPriceText
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        itemQuantity.delegate = self
        origPrice = itemPrice.text!
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.hidden = true
        tapGest = UITapGestureRecognizer(target: self, action: "selectCategory:")
        tapGest.numberOfTapsRequired = 1
        categoryLabel.addGestureRecognizer(tapGest)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if itemQuantity.text == "" {
            itemQuantity.text = "1"
            itemPrice.text = origPrice
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let price = itemPrice.text!
        let justPrice = "\(dropFirst(dropFirst(price)))"
        let justPriceD = (justPrice as NSString).doubleValue
        let q = Double(itemQuantity.text!.toInt()!)
        
        itemPrice.text = "$ \(Double(round(100*(justPriceD*q))/100))"
    }
    
    @IBAction func addItemToCategory(sender: AnyObject) {
//        selectedCategory.set
        performSegueWithIdentifier("presentCategoryFromAdd", sender: self)
    }
    
    func selectCategory(sender: AnyObject) {
        categoryPicker.hidden = false
        categoryPicker.reloadAllComponents()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Add New.." {
            self.addNewCategory()
        }
        else {
            categoryLabel.text = pickerData[row]
        }
        self.categoryPicker.hidden = true
        self.fetchCategories(categoryLabel.text!)
    }
    
    // add category to table view
    func addNewCategory() {
        let addAlert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .Alert)
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelAddCategory))
        addAlert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (UIAlertAction) in
            var catName = self.categoryTextField.text
            for category in self.pickerData {
                if catName == category {
                    catName = "\(catName) copy"
                    break
                }
            }
            self.saveNewCategory(catName)
            self.categoryLabel.text = catName
        }))
        addAlert.addTextFieldWithConfigurationHandler(configTextField)
        self.presentViewController(addAlert, animated: true, completion: nil)
    }
    
    // save category to core data
    func saveNewCategory(name: String) {
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
            self.fetchCategories("")
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
    
    // fetch categories from core data
    func fetchCategories(nameToFetch: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest(entityName:"Category")
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            categories = results
            pickerData = []
            for category in categories {
                let catName = category.valueForKey("name") as! String
                if nameToFetch == catName {
                    selectedCategory = category
                }
                pickerData.append(catName)
            }
            pickerData.append("Add New..")
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentCategoryFromAdd" {
            if let destVC = segue.destinationViewController as? PantryListViewController {
                
            }
        }
    }
}