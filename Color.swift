//
//  Color.swift
//  ColorCollection
//
//  Created by Jason on 4/7/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import CoreData

@objc(Color)

class Color: NSManagedObject {

    // We will store UIColor values in this value attribute
    @NSManaged var value: UIColor
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(insertIntoMangedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Color", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        value = UIColor.whiteColor()
    }
    
}
