//
//  ScoreStorageManager.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 10.03.22.
//

import UIKit
import CoreData

class ScoreStorageManager : StorageManager {
    
    //MARK: Function
    func fetchData() -> [Score] {
        let request: NSFetchRequest<Score> = Score.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Score]()
    }
    
    func getTools(score: Int16, date: String) -> [Score] {
        let request: NSFetchRequest<Score> = Score.fetchRequest()

        request.predicate = NSPredicate(format: "score = %@ AND date = %@",
                                        argumentArray: [score, date])
        
        let results = try? backgroundContext.fetch(request)
        if results?.count != 0 { return results ?? [Score]() }
        return [Score]()
    }

    func insert(currentScore: Int16, date: String) {
        guard let score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: backgroundContext) as? Score else { return }
        score.score = currentScore
        score.date = date
        self.save()
    }
    
    func updateLoan(currentScore: Int16, date: String) {
        let request: NSFetchRequest<Score> = Score.fetchRequest()

        request.predicate = NSPredicate(format: "score = %@ AND date = %@",
                                             argumentArray: [currentScore, date])
        //fetchrequestidan tavidan mogak, fetch result controller kovel cvlilebaze axali
        do {
            let results = try backgroundContext.fetch(request)
            self.insert(currentScore: currentScore, date: date)
            if results.count != 0 {
                self.remove(objectID: results[0].objectID)
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        self.save()
    }
    
    func remove(objectID: NSManagedObjectID) {
        let object = backgroundContext.object(with: objectID)
        backgroundContext.delete(object)
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
}
