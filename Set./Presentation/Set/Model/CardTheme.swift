//
//  CardTheme.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

final class CardTheme {
    
    struct Symbol {
        static let circle = "●"
        static let square = "◼︎"
        static let triangle = "▲"
    }
    
    struct Color {
        static let red = UIColor(named: "red")
        static let green = UIColor(named: "green")
        static let purple = UIColor(named: "purple")
    }
    
    private static func setSymbol(withCard: Card) -> String {
        switch withCard.cardSymbol {
        case .circle:
            return Symbol.circle
        case .square:
            return Symbol.square
        case .triangle:
            return Symbol.triangle
        }
    }
    
    private static func setColor(withCard: Card) -> UIColor {
        switch withCard.cardColor {
        case .red:
            return Color.red ?? .red
        case .green:
            return Color.green ?? .green
        case .purple:
            return Color.purple ?? .purple
        }
    }
    
    private static func setNumber(withCard: Card, withSymbol: String) -> String {
        switch withCard.cardNumber {
        case .one:
            return "\(withSymbol)"
        case .two:
            return "\(withSymbol) \(withSymbol)"
        case .three:
            return "\(withSymbol) \(withSymbol) \(withSymbol)"
        }
    }
    
    private static func setShading(withCard: Card, withColor: UIColor, withNumber: String) -> NSAttributedString {
        var attributedString: [NSAttributedString.Key : Any] = [:]
        switch withCard.cardShading {
        case .filled:
            attributedString[.strokeWidth] = 1
            attributedString[.foregroundColor] = withColor
        case .outlined:
            attributedString[.strokeWidth] = -1
            attributedString[.foregroundColor] = withColor
        case .striped:
            attributedString[.strokeWidth] = -1
            attributedString[.foregroundColor] = withColor.withAlphaComponent(3/20)
        }
        
        return NSAttributedString(string: withNumber, attributes: attributedString)
    }
    
    static func setCard(card: Card) -> NSAttributedString {
        let color = setColor(withCard: card)
        let symbol = setSymbol(withCard: card)
        let number = setNumber(withCard: card, withSymbol: symbol)
        let shading = setShading(withCard: card, withColor: color, withNumber: number)
        
        return shading
    }
}
