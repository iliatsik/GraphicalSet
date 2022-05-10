//
//  SetViewModel.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 17.02.22.
//

import Foundation
import Combine
import CoreData

struct CardInfo {
    var index: Int?
    var title: NSAttributedString?
    var isHidden: Bool?
    var isEnabled: Bool?
}

final class SetViewModel {
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    var set = SetModel()
    @Published var score = 0

    var cardInfoList = [CardInfo](repeating: .init() , count: 24)
    var setChecker = false
    var selectedTwice = false
        
    private var coreDataStack: CoreDataStack
    
    func onLoad() { newGame() }
    
    func newGame() {
        let currentScore = Score(context: self.coreDataStack.managedContext)
        currentScore.score = Int16(score)
        currentScore.date = Date().shortDateFormatter()
        self.coreDataStack.saveContext()
        
        score = 0
        set.availableCards.removeAll()
        set.currentCards.removeAll()
        set.selectedCards.removeAll()
        generateAllCardCombinations()
        addCards(numberOfCardsToSelect: 24)
        firstUpdateCardModel()
    }
    
    func addThreeCard() {
        var addition = 0
        for index in 0..<cardInfoList.count {
            if cardInfoList[index].isHidden == true {
                cardInfoList[index].isHidden = false
                cardInfoList[index].isEnabled = true
                addition += 1
            }
            if addition == 3 { return }
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        return cardIsSelected(card: set.currentCards[index])
    }
    
    private func generateAllCardCombinations() {
        for color in Card.Color.allCases {
            for symbol in Card.Symbol.allCases {
                for number in Card.Number.allCases {
                    for shading in Card.Shading.allCases {
                        let card = Card(cardSymbol: symbol, cardColor: color, cardNumber: number, cardShading: shading)
                        set.availableCards.append(card)
                    }
                }
            }
        }
    }
    
    private func firstUpdateCardModel() {
        for index in 0..<24 {
                cardInfoList[index].index = index
                cardInfoList[index].title = CardTheme.setCard(card: set.currentCards[index])
                cardInfoList[index].isHidden = (index > 3 && index < 16) ? false : true
                cardInfoList[index].isEnabled = (index > 3 && index < 16) ? true : false
        }
    }
    
    
    private func updateCardModel() {
        for index in 0..<24 {
                cardInfoList[index].index = index
                cardInfoList[index].title = CardTheme.setCard(card: set.currentCards[index])
        }
    }
    
    private func addCard() {
        let selectedCard = set.availableCards.remove(at: Int.random(in: 0..<set.availableCards.count))
        set.currentCards.append(selectedCard)
    }
    
    func addCards(numberOfCardsToSelect numberOfCards: Int) {
        for _ in 0..<numberOfCards {
            addCard()
        }
    }
    
    func cardIsSelected(card: Card) -> Bool {
        return set.selectedCards.firstIndex(of: card) != nil
    }
    
    func isSet() -> Bool {
        if set.selectedCards.count != 3 {
            return false
        }
        
        if set.selectedCards[0].cardColor == set.selectedCards[1].cardColor {
            if set.selectedCards[0].cardColor != set.selectedCards[2].cardColor {
                return false
            }
        } else if set.selectedCards[1].cardColor == set.selectedCards[2].cardColor {
            return false
        } else if (set.selectedCards[0].cardColor == set.selectedCards[2].cardColor) {
            return false
        }
        
        if set.selectedCards[0].cardNumber == set.selectedCards[1].cardNumber {
            if set.selectedCards[0].cardNumber != set.selectedCards[2].cardNumber {
                return false
            }
        } else if set.selectedCards[1].cardNumber == set.selectedCards[2].cardNumber {
            return false
        } else if (set.selectedCards[0].cardNumber == set.selectedCards[2].cardNumber) {
            return false
        }
        
        if set.selectedCards[0].cardShading == set.selectedCards[1].cardShading {
            if set.selectedCards[0].cardShading != set.selectedCards[2].cardShading {
                return false
            }
        } else if set.selectedCards[1].cardShading == set.selectedCards[2].cardShading {
            return false
        } else if (set.selectedCards[0].cardShading == set.selectedCards[2].cardShading) {
            return false
        }
        
        if set.selectedCards[0].cardSymbol == set.selectedCards[1].cardSymbol {
            if set.selectedCards[0].cardSymbol != set.selectedCards[2].cardSymbol {
                return false
            }
        } else if set.selectedCards[1].cardSymbol == set.selectedCards[2].cardSymbol {
            return false
        } else if (set.selectedCards[0].cardSymbol == set.selectedCards[2].cardSymbol) {
            return false
        }
        return true
    }
    
    func select(at index: Int) {
        let card = set.currentCards[index]
        
        if let cardToSelect = set.selectedCards.firstIndex(of: card) {
            // Card is already selected, so we are removing it from the selection
            selectedTwice = false
            set.selectedCards.remove(at: cardToSelect)
        } else {
            selectedTwice = true
            set.selectedCards.append(card)
        }
        
        if set.selectedCards.count == 3 && isSet() {
            set.selectedCards.forEach {
                if let selectedCardInGameIndex = set.currentCards.firstIndex(of: $0) {
                    set.currentCards.remove(at: selectedCardInGameIndex)
                    if set.availableCards.count > 0 {
                        let selectedCard = set.availableCards.remove(at: Int.random(in: 0..<set.availableCards.count))
                        set.currentCards.insert(selectedCard, at: selectedCardInGameIndex)
                    }
                }
            }
            updateCardModel()
            score += 3
            setChecker = true
            set.selectedCards.removeAll()
        } else if set.selectedCards.count == 3 && !isSet() {
            score -= 1
            setChecker = false
            set.selectedCards.removeAll()
        }
    }
}

