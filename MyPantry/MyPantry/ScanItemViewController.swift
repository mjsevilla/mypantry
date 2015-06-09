//
//  ScanItemViewController.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/5/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ScanItemViewController: RSCodeReaderViewController {

    @IBOutlet weak var flashBtn: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var toggle: UIBarButtonItem!
    var barcodeVal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("======ScanItemViewController======")
        println("This tab allows users to scan an item's barcode to easily add an item to a category.")
        println("Go ahead! Scan the barcode of something!!")
        
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        self.cornersLayer.strokeColor = UIColor.redColor().CGColor
        self.tabBarController?.tabBar.hidden = false
        
        self.tapHandler = { point in
            println("You focused at location: \(point)")
        }
        self.barcodesHandler = { barcodes in
            if barcodes[0].stringValue != nil {
                println("Barcode found: type=\(barcodes[0].type) value=\(barcodes[0].stringValue)")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.indicator.startAnimating()
                    })
                    
                    self.barcodeVal = barcodes[0].stringValue
                    //put API here??
                    self.session.stopRunning()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.indicator.stopAnimating()
                        self.performSegueWithIdentifier("presentAddItem", sender: self)
                    })
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
    
    func semanticAPICall(barcodeVal: Int) {
        var urlString = "https://api.semantics3.com/test/v1/products?q={\"upc\":70411576937}"
        var esc = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var request = NSMutableURLRequest(URL: NSURL(string: esc!)!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var err: NSError?
        
        request.HTTPMethod = "GET"
        request.addValue("SEM32047A91FE30E73559F6FD1C695F2727B", forHTTPHeaderField: "api_key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var session = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                //this is where the error is printed
                println(error)
                var parseError : NSError?
                // parse data
                let unparsedArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                if let resp = unparsedArray as? NSDictionary {
                    var d = resp["results"] as! NSArray
                    var dict = d[0] as! NSDictionary
                    println(dict["name"])
                    println(dict["price"])
                }
            }
        })
        task.resume()
    }
    
    @IBAction func toggleLight(sender: AnyObject) {
        println("You toggled the flash for scanning items in low-light conditions. Sneaky you!")
        self.toggleTorch()
        let on = UIImage(named: "flash2")
        let off = UIImage(named: "flash")
        flashBtn.image = (flashBtn.image == on) ? off : on
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentAddItem" {
            if let navVC = segue.destinationViewController as? UINavigationController {
                if let destVC = navVC.topViewController as? AddItemViewController {
                    destVC.barcodeVal = self.barcodeVal
                }
            }
        }
    }
}

