//
//  ModelObjects.swift
//  MyPantry
//
//  Created by Mike Sevilla & Cameron Javier on 5/27/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var name: String?
    var items: [String]?
    
    init(name: String?) {
        self.name = name
        self.items = []
    }
}