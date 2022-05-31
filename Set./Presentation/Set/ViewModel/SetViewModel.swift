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
}

final class SetViewModel {
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    var set = SetModel()
    @Published var score = 0

    var cardInfoList = [CardInfo]()
    var setChecker = false
    var selectedTwice = false
        
    private var coreDataStack: CoreDataStack
    
    func onLoad() {
        score = 0
        set.availableCards.removeAll()
        set.currentCards.removeAll()
        set.selectedCards.removeAll()
        cardInfoList.removeAll()
        cardInfoList = [CardInfo](repeating: .init(), count: 12)
        generateAllCardCombinations()
        addCards(numberOfCardsToSelect: 12)
        updateCardModel()
    }
    
    func newGame() {
        let currentScore = Score(context: self.coreDataStack.managedContext)
        currentScore.score = Int16(score)
        currentScore.date = Date().shortDateFormatter()
        self.coreDataStack.saveContext()
        onLoad()
    }
    
    func addThreeCard() {
        addCards(numberOfCardsToSelect: 3)
        lastUpdateCardModel()
    }
    
    func isSelected(at index: Int) -> Bool {
        if set.currentCards.count > index {
            return cardIsSelected(card: set.currentCards[index])
        } else {
            return false
        }
    }
    
    func isDisabledAddThreeCardButton() -> Bool {
        if set.availableCards.count < 3 {
            return true
        } else {
            return false
        }
    }
    
    func shuffleCards() {
        set.currentCards.shuffle()
        updateCardModel()
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
    
    private func updateCardModel() {
        for index in 0..<set.currentCards.count {
            cardInfoList[index].index = index
            cardInfoList[index].title = CardTheme.setCard(card: set.currentCards[index])
        }
    }
    
    private func lastUpdateCardModel() {
        for index in set.currentCards.count - 3..<set.currentCards.count {
            cardInfoList.append(.init(index: index,
                                      title: CardTheme.setCard(card: set.currentCards[index])))
        }
    }
    
    private func addCard() {
        if set.availableCards.count > 0 {
            let selectedCard = set.availableCards.remove(at: Int.random(in: 0..<set.availableCards.count))
            set.currentCards.append(selectedCard)
        }
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
        
        // Here we check if cards are set
        if set.selectedCards.count == 3 && isSet() {
            // If it is set we check three selected card
            set.selectedCards.forEach {
                if let selectedCardInGameIndex = set.currentCards.firstIndex(of: $0) {
                    set.currentCards.remove(at: selectedCardInGameIndex)
                    //We remove that card and check two condition. First: when every available card is used. Second: when it is not
                        // When we have available card, we randomly use one card and will insert in the setted place
                        if set.availableCards.count > 0 {
                            let selectedCard = set.availableCards.remove(at: Int.random(in: 0..<set.availableCards.count))
                            set.currentCards.insert(selectedCard, at: selectedCardInGameIndex)
                        }
                        // When we do not have any available cards we are just removing card's features from the cardInfoList
                        if set.availableCards.count == 0 {
                            cardInfoList.remove(at: selectedCardInGameIndex)
                        }
                    
                }
            }
            // After removing and inserting, then we update card info.
            updateCardModel()
            score += 3
            // setChecker is used for animation
            setChecker = true
            set.selectedCards.removeAll()
        } else if set.selectedCards.count == 3 && !isSet() {
            score -= 1
            setChecker = false
            set.selectedCards.removeAll()
        }
    }
}

