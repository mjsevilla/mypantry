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

    @IBOutlet weak var toggle: UIBarButtonItem!
    var barcodeVal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.clearColor().CGColor
        self.cornersLayer.strokeColor = UIColor.redColor().CGColor
        
        self.tapHandler = { point in
            println(point)
        }
        self.barcodesHandler = { barcodes in
            println("Barcode found: type=\(barcodes[0].type) value=\(barcodes[0].stringValue)")
            self.barcodeVal = barcodes[0].stringValue
            println("This is where a barcode is scanned and segues to adding an item")
            self.performSegueWithIdentifier("presentAddItem", sender: self)
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
        self.toggleTorch()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentAddItem" {
            if let destVC = segue.destinationViewController as? AddItemViewController {
                destVC.barcodeVal = self.barcodeVal
                println("Reaching prepareForSegue()")
            }
        }
    }
}

