//
//  RookDeck.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/10/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import Foundation

class RookDeck {
    private var cards: [RookCard] = []

    init() {
        // Here we build a new deck in order of suit and rank.
        for suit in RookCard.Suit.validSuits {
            if suit == RookCard.Suit.rook {
                cards.append(RookCard())
            } else {
                for rank in RookCard.Rank.min ... RookCard.Rank.max {
                    cards.append(RookCard(suit: suit, rank: rank))
                }
            }
        }
    }

    subscript(index: Int) -> RookCard {
        return cards[index]
    }

    var count: Int {
        return cards.count
    }

    func shuffle() {
        // Our strategy is to randomly pick a card from the deck, put it at the end of a new array,
        // and repeat until we've picked all the cards.  The new array is the shuffled deck.
        var newCards: [RookCard] = []

        while cards.count > 0 {
            // This is the recipe for generating a random integer
            // within the range of valid indexes for an array:
            let index = Int(arc4random()) % cards.count

            cards[index].isFaceUp = false
            newCards.append(cards[index])
            cards.remove(at: index)
        }

        cards = newCards
    }
}
