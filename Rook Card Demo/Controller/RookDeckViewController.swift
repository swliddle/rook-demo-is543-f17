//
//  RookDeckViewController.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/9/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit

class RookDeckViewController : UIViewController {

    // MARK: - Constants
    
    private struct Storyboard {
        static let CardCellIdentifier = "RookCardCell"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var deck = RookDeck()
    var queuedReload = false

    // MARK: - Actions
    
    @IBAction func shuffle(_ sender: UIBarButtonItem) {
        deck.shuffle()
        collectionView.reloadData()
    }
    
    @IBAction func flipAll(_ sender: UIBarButtonItem) {
        let isFaceUp = !deck[0].isFaceUp

        queuedReload = false
        
        for i in 0 ..< deck.count {
            if let rookCardCell = collectionView.cellForItem(at: IndexPath(row: i, section: 0))
                                                                                as? RookCardCell {
                if deck[i].isFaceUp != isFaceUp {
                    deck[i].isFaceUp = isFaceUp
                    flipCard(inCell: rookCardCell, withReload: true)
                }
            } else {
                deck[i].isFaceUp = isFaceUp
            }
        }
    }
    
    @IBAction func toggleSize(_ sender: UIBarButtonItem) {
        collectionView.layoutIfNeeded()
        
        if collectionViewBottomConstraint.constant > 0 {
            collectionViewBottomConstraint.constant = 0
        } else {
            collectionViewBottomConstraint.constant = collectionView.bounds.height / 2
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func flipCard(inCell rookCardCell: RookCardCell, withReload needsReload: Bool = false) {
        UIView.transition(
            with: rookCardCell.rookCardView,
            duration: 0.5,
            options: .transitionFlipFromLeft,
            animations: {
                rookCardCell.rookCardView.isFaceUp = !rookCardCell.rookCardView.isFaceUp
                rookCardCell.rookCardView.setNeedsDisplay()
            },
            completion: {
                [unowned self] (finished: Bool) -> () in
                if !self.queuedReload {
                    self.queuedReload = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1,
                                                  execute: {
                                                    self.collectionView.reloadData()
                    })
                }
            })
    }
}

extension RookDeckViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Storyboard.CardCellIdentifier,
            for: indexPath)
        let card = deck[indexPath.row]
        
        if let rookCardCell = cell as? RookCardCell {
            rookCardCell.rookCardView.isFaceUp = card.isFaceUp
            rookCardCell.rookCardView.rank = card.rank
            rookCardCell.rookCardView.suit = card.suit
            rookCardCell.rookCardView.setNeedsDisplay()
        }
        
        return cell
    }
}

extension RookDeckViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let rookCardCell = collectionView.cellForItem(at: indexPath) as? RookCardCell {
            deck[indexPath.row].isFaceUp = !deck[indexPath.row].isFaceUp
            flipCard(inCell: rookCardCell)
        }
    }
}
