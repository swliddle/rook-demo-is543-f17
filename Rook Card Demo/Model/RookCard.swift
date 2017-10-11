//
//  RookCard.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/10/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import Foundation

class RookCard {
    
    // MARK: - Nested types
    
    struct Rank {
        static let rook = 0
        static let min = 1
        static let max = 14
    }

    enum Suit : String {
        case rook, red, green, yellow, black

        var description: String {
            return self.rawValue.uppercased()
        }

        static let validSuits: [Suit] = [.rook, .red, .green, .yellow, .black]
    }

    // MARK: - Properties

    var isFaceUp = false
    var rank = Rank.rook
    var suit = Suit.rook

    // MARK: - Initialization

    init() {
        // By default this builds a Rook card
    }

    init(suit: Suit, rank: Int) {
        self.suit = suit
        self.rank = rank
    }
}
