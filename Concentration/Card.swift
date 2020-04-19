//
//  Card.swift
//  Concentration
//
//  Created by Gary Kim on 3/29/20.
//  Copyright © 2020 Gary Kim. All rights reserved.
//

import Foundation

struct Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    var isFaceUp      = false
    var isMatched     = false
    var hasBeenChosen = false
    
    private(set) var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    init(withIdentifier identifier: Int) {
        self.identifier = identifier
    }
}

