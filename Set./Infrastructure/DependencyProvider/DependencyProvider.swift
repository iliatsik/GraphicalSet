//
//  DependencyProvider.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 27.05.22.
//

import Foundation
import UIKit
import CoreData

struct DependencyProvider {
    
    static var coreDataStack: CoreDataStack {
        return CoreDataStack(modelName: "Data")
    }
    
    static var scoreRepository: ScoreRepository {
        return ScoreRepository(coreDataStack: coreDataStack)
    }
    
    static var fetchDelegate: NSFetchedResultsControllerDelegate {
        return scoreViewController as! NSFetchedResultsControllerDelegate
    }
    
    static var setViewModel: SetViewModel {
        return SetViewModel(coreDataStack: coreDataStack)
    }
    
    static var setViewController: UIViewController {
        let vc = SetViewController()
        vc.viewModel = setViewModel
        return vc
    }
    
    static var scoreViewModel: ScoreViewModel {
        return ScoreViewModel(scoreRepository: scoreRepository)
    }
    
    static var scoreViewController: UIViewController {
        let vc = ScoreViewController()
        vc.viewModel = scoreViewModel
        return vc
    }
}
