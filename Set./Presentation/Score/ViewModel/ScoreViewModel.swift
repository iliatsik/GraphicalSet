//
//  ScoreViewModel.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 06.05.22.
//

import Foundation

final class ScoreViewModel {
    
    var scoreRepository: ScoreRepository
    
    init(scoreRepository: ScoreRepository) {
        self.scoreRepository = scoreRepository
    }

    func numberOfSections() -> Int {
        scoreRepository.coreDataFetchedResults.controller.sections?.count ?? 0
    }
    
    func numberOfRows(at section: Int) -> Int {
        scoreRepository.coreDataFetchedResults.controller.sections![section].numberOfObjects
    }
    
    func score(at indexPath: IndexPath) -> Score {
        scoreRepository.coreDataFetchedResults.controller.object(at: indexPath)
    }
    
    func deleteScore(at indexPath: IndexPath) {
        scoreRepository.coreDataFetchedResults.managedContext.delete(score(at: indexPath))
    }
    
    func performFetch() {
        scoreRepository.coreDataFetchedResults.performFetch()
    }
}
