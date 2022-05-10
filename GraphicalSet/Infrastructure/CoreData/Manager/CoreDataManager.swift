//
//  CoreDataManager.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.03.22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var context = persistentContainer.viewContext

    var scores: [Score]?

    func fetchScore() {
        do {
            self.scores = try context.fetch(Score.fetchRequest())
        }
        catch {
            print(error)
        }
    }
    
    func updateScore(at index: Int, with score: Int16) {
        guard let scores = scores else { return }
        scores[index].score = score
        scores[index].date = Date().format()
        
        do {
            try self.context.save()
        }
        catch {
            print(error)
        }
        
        fetchScore()
    }
    
    func createScore(with score: Int16) {
        let newScore = Score(context: self.context)
        newScore.score = score
        newScore.date = Date().format()
        
        do {
            try self.context.save()
        }
        catch {
            print(error)
        }
        
        fetchScore()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Data")
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
