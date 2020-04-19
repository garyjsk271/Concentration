//
//  Concentration.swift
//  Concentration
//
//  Created by Gary Kim on 3/29/20.
//  Copyright © 2020 Gary Kim. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var nEmojiThemes: Int
    private(set) var emojiThemeIdentifier: Int
    private(set) var score = 0
    
    private var iOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{ cards[$0].isFaceUp }.oneAndOnly
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func isOver() -> Bool {
        for card in cards {
            if !card.isMatched {
                return false
            }
        }
        return true
    }
    
    func incrementFlipCount() {
        flipCount += 1
    }
    
    func reset(nPairsOfCards: Int, nEmojiThemes: Int) {
        cards.removeAll()
        flipCount = 0
        emojiThemeIdentifier = nEmojiThemes.arc4random
        score = 0
        
        for _ in 0..<nPairsOfCards {
            let card = Card()
            cards += [card, -card]
        }
        cards.shuffle()
    }
    
    func chooseOtherCard(of card: Card) {
        for index in cards.indices {
            if -cards[index].identifier == card.identifier {
                cards[index].hasBeenChosen = true
                return
            }
        }
    }
    
    func chooseCard(at index:Int) {
        if !cards[index].isMatched {
            if let matchIndex = iOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    if cards[matchIndex].hasBeenChosen {
                        score -= 1
                    }
                    if cards[index].hasBeenChosen {
                        
                        score -= 1
                    }
                    cards[index].hasBeenChosen      = true
                    cards[matchIndex].hasBeenChosen = true
                    chooseOtherCard(of: cards[index])
                    chooseOtherCard(of: cards[matchIndex])
                }
                cards[index].isFaceUp = true
            } else {
                iOneAndOnlyFaceUpCard = index
            }
            
            if self.isOver() {
                setAllCardsFaceDown()
                return
            }
        }
    }
    
    private func setAllCardsFaceDown() {
        for index in cards.indices {
            cards[index].isFaceUp = false
        }
    }
    
    init(nPairsOfCards: Int, nEmojiThemes: Int) {
        for _ in 0..<nPairsOfCards {
            let card = Card()
            cards += [card, -card]
        }
        cards.shuffle()
        
        self.nEmojiThemes = nEmojiThemes
        emojiThemeIdentifier = nEmojiThemes.arc4random
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension Card {
    static prefix func - (card: Card) -> Card {
        return Card(withIdentifier: -card.identifier)
    }
}
