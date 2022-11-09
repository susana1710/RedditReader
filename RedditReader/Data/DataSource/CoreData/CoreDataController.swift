//
//  CoreDataController.swift
//  RedditReader
//
//  Created by Susana Charara on 9/11/22.
//

import Foundation
import CoreData

public class CoreDataController: NSObject {

  static let shared = CoreDataController(inMemoryStore: false)

  private var isInmemoryStore = false

  // MARK: - Core Data stack
  private var managedObjectContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  private var managedObjectModel: NSManagedObjectModel {
    return persistentContainer.managedObjectModel
  }

  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name:"RedditReader")
    if isInmemoryStore {
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      container.persistentStoreDescriptions = [description]
    }
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  convenience init(inMemoryStore: Bool) {
    self.init()
    self.isInmemoryStore = inMemoryStore
  }

  func getContext () -> NSManagedObjectContext {
    return managedObjectContext
  }

  // MARK: - Core Data Saving support

  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

}
