//
//  ScanItemViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit
import AVFoundation

class ScanItemViewController: RSCodeReaderViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var toggle: UIBarButtonItem!
    var barcodeVal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("======ScanItemViewController======")
        println("This tab allows users to scan an item's barcode to easily add an item to a category.")
        println("Go ahead! Scan the barcode of something!!")
        
        self.focusMarkLayer.strokeColor = UIColor.clearColor().CGColor
        self.cornersLayer.strokeColor = UIColor.redColor().CGColor
        self.tabBarController?.tabBar.hidden = false
        
        self.tapHandler = { point in
            println("You focused at location: \(point)")
        }
        self.barcodesHandler = { barcodes in
            if barcodes[0].stringValue != nil {
                println("Barcode found: type=\(barcodes[0].type) value=\(barcodes[0].stringValue)")
                self.barcodeVal = barcodes[0].stringValue
                dispatch_async(dispatch_get_main_queue(), {
                    self.indicator.startAnimating()
                    self.session.stopRunning()
                    self.performSegueWithIdentifier("presentAddItem", sender: self)
                })
            }
        }
        
        let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        types.removeObject(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = NSArray(array: types) as [AnyObject]
        
        // MARK: NOTE: If you layout views in storyboard, you should these 3 lines
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as! UIView)
        }
        
        if !self.hasTorch() {
            self.toggle.enabled = false
        }
    }
    
    @IBAction func toggleLight(sender: AnyObject) {
        println("You toggled the flash for scanning items in low-light conditions. Sneaky you!")
        self.toggleTorch()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentAddItem" {
            if let destVC = segue.destinationViewController as? AddItemViewController {
                self.indicator.stopAnimating()
                destVC.barcodeVal = self.barcodeVal
            }
        }
    }
}

