//
//  CoreDataFetchedResults.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 18.03.22.
//

import UIKit
import CoreData

public class CoreDataFetchedResults<T: NSManagedObject> {
    
    var entityName: String!
    var sortDescriptors: [NSSortDescriptor]!
    var managedContext: NSManagedObjectContext!
    
    public lazy var controller: NSFetchedResultsController<T> = {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptors

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
                
        return fetchedResultsController
    }()
    
   
    public init(ofType _: T.Type, entityName: String, sortDescriptors: [NSSortDescriptor], managedContext: NSManagedObjectContext) {
        self.entityName = entityName
        self.sortDescriptors = sortDescriptors
        self.managedContext = managedContext
    }
    
    public func saveContext(completion: @escaping (Result<Bool, Error>) -> () = {_ in}) {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch {
            handle(error) {
                completion(.failure(error))
            }
        }
    }
    
    public func performFetch(completion: @escaping (Result<Bool, Error>) -> () = {_ in}) {
        do {
            try controller.performFetch()
        } catch {
            handle(error) {
                completion(.failure(error))
            }
        }
    }
    
    private func handle(_ error: Error?, completion: @escaping () -> () = {}) {
        if (error as NSError?) != nil {
            completion()
        }
    }
    
}
