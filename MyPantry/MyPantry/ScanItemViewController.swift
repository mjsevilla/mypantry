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
    var itemName = ""
    var itemPrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        self.cornersLayer.strokeColor = UIColor.redColor().CGColor
        self.tabBarController?.tabBar.hidden = false
        self.barcodesHandler = { barcodes in
            if barcodes[0].stringValue != nil {
                println("Barcode found: type=\(barcodes[0].type) value=\(barcodes[0].stringValue)")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.indicator.startAnimating()
                    })
                    
                    self.semanticsAPICall(barcodes[0].stringValue.toInt()!)
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
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as! UIView)
        }
        
        if !self.hasTorch() {
            self.toggle.enabled = false
        }
    }
    
    func semanticsAPICall(barcodeVal: Int) {
        let urlString = "https://api.semantics3.com/test/v1/products?q={\"upc\":\(barcodeVal)}"
        let esc = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let request = NSMutableURLRequest(URL: NSURL(string: esc!)!)
        let response: NSURLResponse?
        let error: NSErrorPointer = nil
        var err: NSError?
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("SEM32047A91FE30E73559F6FD1C695F2727B", forHTTPHeaderField: "api_key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                // parse data
                var parseError: NSError?
                let unparsedArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                if let resp = unparsedArray as? NSDictionary {
                    let d = resp["results"] as! NSArray
                    let dict = d[0] as! NSDictionary
                    let name: AnyObject? = dict["name"]
                    let price: AnyObject? = dict["price"]
                    self.itemName = "\(name!)"
                    self.itemPrice = "$ \(price!)"
                }
            }
        })
        task.resume()
    }
    
    @IBAction func toggleLight(sender: AnyObject) {
        self.toggleTorch()
        let on = UIImage(named: "flash2")
        let off = UIImage(named: "flash")
        flashBtn.image = (flashBtn.image == on) ? off : on
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        flashBtn.image = UIImage(named: "flash")
        if segue.identifier == "presentAddItem" {
            if let navVC = segue.destinationViewController as? UINavigationController {
                if let destVC = navVC.topViewController as? AddItemViewController {
                    destVC.itemName.text = self.itemName
                    destVC.itemPrice.text = self.itemPrice
                }
            }
        }
    }
}

