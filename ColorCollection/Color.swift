//
//  Color.swift
//  ColorCollection
//
//  Created by Jason on 4/7/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//
//  Updated to Swift 4.2 by Mark on 10/3/18

import UIKit
import CoreData

@objc(Color)

class Color: NSManagedObject {
  
  // We will store UIColor values in this value attribute
  @NSManaged var value: UIColor
  
  override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
  }
  
  convenience init(insertIntoMangedObjectContext context: NSManagedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "Color", in: context)!
    self.init(entity: entity, insertInto: context)
    
    value = UIColor.white
  }
  
}
