//
//  ColorViewController.swift
//

import Foundation
import CoreData
import MapKit

/**
 * The color collection demonstrates two techniques that will be useful in the Virtual Tourist app
 *
 * - Selecting and deselecting cells in a collection
 * - Using NSFecthedResultsController with a collection
 *
 * Before you proceed, take a minute to run the app, and then read the Readme file. It gives a brief introduction to these
 * two topics.
 */

class ColorsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
  
  // The selected indexes array keeps all of the indexPaths for cells that are "selected". The array is
  // used inside cellForItemAtIndexPath to lower the alpha of selected cells.  You can see how the array
  // works by searchign through the code for 'selectedIndexes'
  var selectedIndexes = [NSIndexPath]()
  
  // Keep the changes. We will keep track of insertions, deletions, and updates.
  var insertedIndexPaths: [NSIndexPath]!
  var deletedIndexPaths: [NSIndexPath]!
  var updatedIndexPaths: [NSIndexPath]!
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bottomButton: UIBarButtonItem!
  
  var cancelButton: UIBarButtonItem!
  
  var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
  
  override func viewDidLoad() {
    print("in viewDidLoad()")
    
    super.viewDidLoad()
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ColorsViewController.addColor(_:)))
    self.navigationItem.rightBarButtonItem = addButton
    
    // Start the fetched results controller
    var error: NSError?
    do {
      try fetchedResultsController.performFetch()
    } catch let error1 as NSError {
      error = error1
    }
    
    if let error = error {
      print("Error performing initial fetch: \(error)")
    }
    
    updateBottomButton()
  }
  
  // Layout the collection view
  
  override func viewDidLayoutSubviews() {
    print("in viewDidLayoutSubviews()")
    super.viewDidLayoutSubviews()
    
    // Lay out the collection view so that cells take up 1/3 of the width,
    // with no space in between.
    let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let width = floor(self.collectionView.frame.size.width/3)
    layout.itemSize = CGSize(width: width, height: width)
    collectionView.collectionViewLayout = layout
  }
  
  
  // MARK: - Configure Cell
  
  func configureCell(cell: ColorCell, atIndexPath indexPath: NSIndexPath) {
    print("in configureCell")
    let color = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Color
    
    cell.color = color.value
    cell.rgbLabel.text = String(color.value)
    print(String(color.value))
    
    // If the cell is "selected" it's color panel is grayed out
    // we use the Swift `find` function to see if the indexPath is in the array
    
    if let _ = selectedIndexes.indexOf(indexPath) {
      cell.colorPanel.alpha = 0.05
    } else {
      cell.colorPanel.alpha = 1.0
    }
  }
  
  
  // MARK: - UICollectionView
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    print("in numberOfSectionsInCollectionView()")
    return self.fetchedResultsController.sections?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("in collectionView(_:numberOfItemsInSection)")
    let sectionInfo = self.fetchedResultsController.sections![section]
    
    print("number Of Cells: \(sectionInfo.numberOfObjects)")
    return sectionInfo.numberOfObjects
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    print("in collectionView(_:cellForItemAtIndexPath)")
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath) as! ColorCell
    
    self.configureCell(cell, atIndexPath: indexPath)
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    print("in collectionView(_:didSelectItemAtIndexPath)")
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ColorCell
    
    // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array
    if let index = selectedIndexes.indexOf(indexPath) {
      selectedIndexes.removeAtIndex(index)
    } else {
      selectedIndexes.append(indexPath)
    }
    
    // Then reconfigure the cell
    configureCell(cell, atIndexPath: indexPath)
    
    // And update the buttom button
    updateBottomButton()
  }
  
  
  // MARK: - NSFetchedResultsController
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    
    let fetchRequest = NSFetchRequest(entityName: "Color")
    fetchRequest.sortDescriptors = []
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  
  // MARK: - Fetched Results Controller Delegate
  
  // Whenever changes are made to Core Data the following three methods are invoked. This first method is used to create
  // three fresh arrays to record the index paths that will be changed.
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    
    // We are about to handle some new changes. Start out with empty arrays for each change type
    insertedIndexPaths = [NSIndexPath]()
    deletedIndexPaths = [NSIndexPath]()
    updatedIndexPaths = [NSIndexPath]()
    
    print("in controllerWillChangeContent")
  }
  
  // The second method may be called multiple times, once for each Color object that is added, deleted, or changed.
  // We store the incex paths into the three arrays.
  
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
      
    case .Insert:
      print("Insert an item")
      // Here we are noting that a new Color instance has been added to Core Data. We remember its index path
      // so that we can add a cell in "controllerDidChangeContent". Note that the "newIndexPath" parameter has
      // the index path that we want in this case
      insertedIndexPaths.append(newIndexPath!)
      break
    case .Delete:
      print("Delete an item")
      // Here we are noting that a Color instance has been deleted from Core Data. We keep remember its index path
      // so that we can remove the corresponding cell in "controllerDidChangeContent". The "indexPath" parameter has
      // value that we want in this case.
      deletedIndexPaths.append(indexPath!)
      break
    case .Update:
      print("Update an item.")
      // We don't expect Color instances to change after they are created. But Core Data would
      // notify us of changes if any occured. This can be useful if you want to respond to changes
      // that come about after data is downloaded. For example, when an images is downloaded from
      // Flickr in the Virtual Tourist app
      updatedIndexPaths.append(indexPath!)
      break
    case .Move:
      print("Move an item. We don't expect to see this in this app.")
      break
      //default:
      //break
    }
  }
  
  
  // This method is invoked after all of the changed in the current batch have been collected
  // into the three index path arrays (insert, delete, and upate). We now need to loop through the
  // arrays and perform the changes.
  //
  // The most interesting thing about the method is the collection view's "performBatchUpdates" method.
  // Notice that all of the changes are performed inside a closure that is handed to the collection view.
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    
    print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count + deletedIndexPaths.count)")
    
    collectionView.performBatchUpdates({() -> Void in
      
      for indexPath in self.insertedIndexPaths {
        self.collectionView.insertItemsAtIndexPaths([indexPath])
      }
      
      for indexPath in self.deletedIndexPaths {
        self.collectionView.deleteItemsAtIndexPaths([indexPath])
      }
      
      for indexPath in self.updatedIndexPaths {
        self.collectionView.reloadItemsAtIndexPaths([indexPath])
      }
      
      }, completion: nil)
  }
  
  // MARK: - Actions and Helpers
  
  @IBAction func addColor(sender: UIButton) {
    let red = CGFloat(Float(arc4random() % 10000) / 10000.0)
    let green = CGFloat(Float(arc4random() % 10000) / 10000.0)
    let blue = CGFloat(Float(arc4random() % 10000) / 10000.0)
    
    let color = Color(insertIntoMangedObjectContext: sharedContext)
    color.value = UIColor(red: red, green: green, blue: blue, alpha: 1)
    
    CoreDataStackManager.sharedInstance().saveContext()
  }
  
  @IBAction func buttonButtonClicked() {
    
    if selectedIndexes.isEmpty {
      deleteAllColors()
    } else {
      deleteSelectedColors()
    }
  }
  
  func deleteAllColors() {
    
    for color in fetchedResultsController.fetchedObjects as! [Color] {
      sharedContext.deleteObject(color)
    }
  }
  
  func deleteSelectedColors() {
    var colorsToDelete = [Color]()
    
    for indexPath in selectedIndexes {
      colorsToDelete.append(fetchedResultsController.objectAtIndexPath(indexPath) as! Color)
    }
    
    for color in colorsToDelete {
      sharedContext.deleteObject(color)
    }
    
    selectedIndexes = [NSIndexPath]()
  }
  
  func updateBottomButton() {
    if selectedIndexes.count > 0 {
      bottomButton.title = "Remove Selected Colors"
    } else {
      bottomButton.title = "Clear All"
    }
  }
}