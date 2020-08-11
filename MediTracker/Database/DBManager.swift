//
//  DBManager.swift
//  MediTracker
//
//  Created by Trupti on 09/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import Foundation
import CoreData

class DBManager {
    
    static let shared = DBManager()
    
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
           /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
           */
           let container = NSPersistentContainer(name: "MediTracker")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                   /*
                    Typical reasons for an error here include:
                    * The parent directory does not exist, cannot be created, or disallows writing.
                    * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    * The device is out of space.
                    * The store could not be migrated to the current model version.
                    Check the error message to determine what the actual problem was.
                    */
                   debugPrint("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchHistory(with date:String)-> MedsHistory?{
        let context = persistentContainer.viewContext
        var historyList:[MedsHistory] = [MedsHistory]()
        let fetchReq : NSFetchRequest<MedsHistory> = MedsHistory.fetchRequest()
        fetchReq.predicate =  NSPredicate(format: "date == %@", date)
        do {
            historyList = try context.fetch(fetchReq)
            if let oneMedsHistory = historyList.first{
                return oneMedsHistory
            }
        } catch  {
            debugPrint("Failed to fetch a request")
        }
        
        return nil
    }
    
    func fetchHistory()-> [MedsHistory]?{
        let context = persistentContainer.viewContext
        let historyList:[MedsHistory]?
        let fetchReq : NSFetchRequest<MedsHistory> = MedsHistory.fetchRequest()
        do {
            historyList = try context.fetch(fetchReq)
            return historyList
        } catch  {
            debugPrint("Failed to fetch a request")
        }
        return nil
    }

    
    func createRecordWith(date:String, score:Int16){
        let context = persistentContainer.viewContext
        let medstaken = MedsHistory(context: context)
        medstaken.date = date
        medstaken.score = score // add score
        saveContext()
    }
    
    
}
