//
//  RookCardView.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/7/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit

@IBDesignable
class RookCardView : UIView {
    
    // MARK: - Constants
    
    private struct Card {
        static let backImageName = "RookBack"
    }
    
    // MARK: - Properties
    
    @IBInspectable var isFaceUp: Bool = true
    @IBInspectable var rank: Int = 1
    @IBInspectable var suit: Int = 1
    
    // MARK: - Computed properties
    
    var cornerRadius: CGFloat { return bounds.width * 0.05 }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        isOpaque = false
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        drawBaseCard()
        
        if isFaceUp {
            drawFaceUp()
        } else {
            drawFaceDown()
        }
    }
    
    private func drawBaseCard() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        roundedRect.addClip()
        UIColor.white.setFill()
        UIRectFill(bounds)
    }
    
    private func drawFaceDown() {
        let rookImage = UIImage(named: Card.backImageName)
        
        rookImage?.draw(in: bounds)
    }
    
    private func drawFaceUp() {
        guard let font = UIFont(name: "Palatino-Bold", size: 150.0) else {
            return
        }
        
        let rankText = NSAttributedString(string: "\(rank)", attributes: [
            .font : font,
            .foregroundColor : UIColor.red
            ])
        
        rankText.draw(at: CGPoint(x: 50, y: 50))
    }
}
