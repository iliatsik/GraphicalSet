//
//  Card.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import Foundation

final class Card: Equatable {
   
    init(cardSymbol: Symbol, cardColor: Color, cardNumber: Number, cardShading: Shading) {
        self.cardColor = cardColor
        self.cardNumber = cardNumber
        self.cardSymbol = cardSymbol
        self.cardShading = cardShading
    }
    
    let cardSymbol: Symbol
    let cardColor: Color
    let cardNumber: Number
    let cardShading: Shading
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.cardNumber == rhs.cardNumber &&
        lhs.cardColor == rhs.cardColor &&
        lhs.cardSymbol == rhs.cardSymbol &&
        lhs.cardShading == rhs.cardShading
    }

    enum Symbol: CaseIterable {
        case square
        case triangle
        case circle
    }

    enum Color: CaseIterable {
        case red
        case green
        case purple
    }

    enum Number: CaseIterable {
        case one
        case two
        case three
    }

    enum Shading: CaseIterable {
        case filled
        case outlined
        case striped
    }
}
