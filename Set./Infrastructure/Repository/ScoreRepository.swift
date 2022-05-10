//
//  ScoreRepository.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 18.03.22.
//

import Foundation
import CoreData
import UIKit
import Combine

class ScoreRepository {
        
    init(delegate: NSFetchedResultsControllerDelegate) {
        self.delegate = delegate
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    var coreDataStack: CoreDataStack?
    var delegate: NSFetchedResultsControllerDelegate?
    
    var subscriber = Set<AnyCancellable>()
    @Published var score: [Score] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<Score> = {

        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack!.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = delegate

        return fetchedResultsController
    }()
    
    
    let dateSort = NSSortDescriptor(key: #keyPath(Score.date), ascending: false)
    lazy var sortDescriptors = [dateSort]
    
    lazy var coreDataFetchedResults = CoreDataFetchedResults(ofType: Score.self,
                                                             entityName: "Score",
                                                             sortDescriptors: sortDescriptors,
                                                             managedContext: coreDataStack!.managedContext,
                                                             delegate: ScoreViewController(),
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
  
}


