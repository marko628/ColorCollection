//
//  CoreDataStackManager.swift
//  FavoriteActors
//
//  Created by Jason on 3/10/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import CoreData

/**
 * The CoreDataStackManager contains the code that was previously living in the
 * AppDelegate in Lesson 3. Apple puts the code in the AppDelegate in many of their
 * Xcode templates. But they put it in a convenience class like this in sample code
 * like the "Earthquakes" project.
 *
 */

private let SQLITE_FILE_NAME = "ColorCollection.sqlite"

class CoreDataStackManager {
  
  
  // MARK: - Shared Instance
  
  /**
   *  This class variable provides an easy way to get access
   *  to a shared instance of the CoreDataStackManager class.
   */
  class func sharedInstance() -> CoreDataStackManager {
    struct Static {
      static let instance = CoreDataStackManager()
    }
    
    return Static.instance
  }
  
  // MARK: - The Core Data stack. The code has been moved, unaltered, from the AppDelegate.
  
  lazy var applicationDocumentsDirectory: URL = {
    
    print("Instantiating the applicationDocumentsDirectory property")
    
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    
    print("Instantiating the managedObjectModel property")
    
    let modelURL = Bundle.main.url(forResource: "ColorCollection", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  /**
   * The Persistent Store Coordinator is an object that the Context uses to interact with the underlying file system. Usually
   * the persistent store coordinator object uses an SQLite database file to save the managed objects. But it is possible to
   * configure it to use XML or other formats.
   *
   * Typically you will construct your persistent store manager exactly like this. It needs two pieces of information in order
   * to be set up:
   *
   * - The path to the sqlite file that will be used. Usually in the documents directory
   * - A configured Managed Object Model. See the next property for details.
   */
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    
    print("Instantiating the persistentStoreCoordinator property")
    
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent(SQLITE_FILE_NAME)
    
    print("sqlite path: \(url.path)")
    
    var error: NSError? = nil
    
    do {
      try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch var error1 as NSError {
      error = error1
      coordinator = nil
      // Report any error we got.
      let dict = NSMutableDictionary()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
      dict[NSUnderlyingErrorKey] = error
      error = NSError(domain: "Color Collection", code: 9999, userInfo: nil)
      
      // Left in for development development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    } catch {
      fatalError()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    
    print("Instantiating the managedObjectContext property")
    
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext()
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    
    if let context = self.managedObjectContext {
      
      var error: NSError? = nil
      
      if context.hasChanges {
        do {
          try context.save()
        } catch let error1 as NSError {
          error = error1
          NSLog("Unresolved error \(error), \(error!.userInfo)")
          abort()
        }
      }
    }
  }
}
