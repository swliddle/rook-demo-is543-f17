//
//  RookCardView.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/7/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0,
                  alpha: 1.0)
    }
}

@IBDesignable
class RookCardView : UIView {
    
    // MARK: - Nested types
    
    enum Suit : String {
        case rook = "rook"
        case red = "red"
        case green = "green"
        case yellow = "yellow"
        case black = "black"
    }

    // MARK: - Constants
    
    private struct Card {
        static let backImageName = "RookBack"
        static let fontName = "Palatino-Bold"
        static let suitColors = [
            Suit.rook   : UIColor(r:  34, g: 193, b: 196),
            Suit.red    : UIColor(r: 237, g:  37, b:  50),
            Suit.green  : UIColor(r:  36, g: 193, b:  80),
            Suit.yellow : UIColor(r: 242, g: 199, b:  58),
            Suit.black  : UIColor.black
        ]
    }
    
    // MARK: - Properties
    
    @IBInspectable var isFaceUp: Bool = true
    @IBInspectable var rank: Int = 1
    var suit = Suit.yellow
    
    // MARK: - Computed properties
    
    var cornerRadius: CGFloat { return bounds.width * 0.05 }
    var centerFontSize: CGFloat { return bounds.width * 0.55 }
    var squareMargin: CGFloat { return bounds.width * 0.189 }
    var squareStrokeWidth: CGFloat { return bounds.width * 0.005 }

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
        if suit == Suit.rook {
            drawCenterImage()
        } else {
            drawCenterText()
            drawCenterSquare()
        }
        
        drawCornerText()
    }
    
    private func drawCenterImage() {
        
    }
    
    private func drawCenterSquare() {
        guard let color = Card.suitColors[suit] else {
            return
        }
        
        let square = UIBezierPath()
        let width = bounds.width - (2.0 * squareMargin)
        let yOffset = (bounds.height - width) / 2
        
        color.setStroke()
        square.lineWidth = squareStrokeWidth
        square.move(to: CGPoint(x: squareMargin, y: yOffset))
        square.addLine(to: CGPoint(x: squareMargin + width, y: yOffset))
        square.addLine(to: CGPoint(x: squareMargin + width, y: yOffset + width))
        square.addLine(to: CGPoint(x: squareMargin, y: yOffset + width))
        square.close()
        square.stroke()
    }
    
    private func drawCenterText() {
        guard let font = UIFont(name: Card.fontName, size: centerFontSize) else {
            return
        }
        
        guard let color = Card.suitColors[suit] else {
            return
        }
        
        let rankText = NSAttributedString(string: "\(rank)", attributes: [
            .font : font,
            .foregroundColor : color
            ])
        var textBounds = CGRect.zero

        textBounds.size = rankText.size()
        textBounds.origin = CGPoint(x: (bounds.width - textBounds.width) / 2,
                                    y: (bounds.height - textBounds.height) / 2)
        rankText.draw(in: textBounds)
        
        if rank == 6 || rank == 9 {
            drawCenterUnderline()
        }
    }
    
    private func drawCenterUnderline() {
        
    }

    private func drawCornerText() {
        
    }
}
