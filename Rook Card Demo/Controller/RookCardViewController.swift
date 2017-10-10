//
//  RookCardViewController.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/7/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit

class RookCardViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var rookCard: RookCardView!
    
    // MARK: - Actions
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(
            with: rookCard,
            duration: 0.5,
            options: sender.direction == .right ?
                .transitionFlipFromLeft :
                .transitionFlipFromRight,
            animations: {
                self.rookCard.isFaceUp = !self.rookCard.isFaceUp
                self.rookCard.setNeedsDisplay()
            },
            completion: nil)
    }
}
