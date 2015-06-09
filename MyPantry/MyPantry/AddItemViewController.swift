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
    var origPrice = ""
    var barcodeVal: String?
    let pickerData = ["fruit", "veggies", "frozens"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        itemQuantity.delegate = self
        origPrice = itemPrice.text!
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
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
        println("You have reviewed the item and selected which category you wish to add this item to.")
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
//        myLabel.text = pickerData[row]
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}