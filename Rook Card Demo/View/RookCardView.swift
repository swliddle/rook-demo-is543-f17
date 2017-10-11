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
        static let cornerRookImageName = "RookSquareTurquoise"
        static let fontName = "Palatino-Bold"
        static let rookImageName = "RookSquare"
        static let suitColors: [RookCard.Suit : UIColor] = [
                                .rook   : UIColor(r:  34, g: 193, b: 196),
                                .red    : UIColor(r: 237, g:  37, b:  50),
                                .green  : UIColor(r:  36, g: 193, b:  80),
                                .yellow : UIColor(r: 242, g: 199, b:  58),
                                .black  : UIColor.black
                            ]
        static let underlinedRanks = [ 6, 9 ]
    }

    // MARK: - Properties

    var card = RookCard()

    // MARK: - Computed properties
    
    @IBInspectable var isFaceUp: Bool {
        get {
            return card.isFaceUp
        }
        set {
            card.isFaceUp = newValue
        }
    }

    @IBInspectable var rank: Int {
        get {
            return card.rank
        }
        set {
            card.rank = newValue
        }
    }

    @IBInspectable var suit: String {
        get {
            return card.suit.description
        }
        set {
            if let newSuit = RookCard.Suit(rawValue: newValue) {
                card.suit = newSuit
            }
        }
    }

    // See slides for explanations of the uses of these computed properties

    var centerFontSize       : CGFloat { return bounds.width * 0.55 }
    var centerImageMargin    : CGFloat { return bounds.width * 0.15 }
    var cornerImageWidth     : CGFloat { return bounds.width * 0.18 }
    var cornerRadius         : CGFloat { return bounds.width * 0.05 }
    var cornerRankFontSize   : CGFloat { return bounds.width * 0.2 }
    var cornerSuitFontSize   : CGFloat { return bounds.width * 0.0666 }
    var cornerSuitOffset     : CGFloat { return bounds.width * 0.01 }
    var cornerXOffset        : CGFloat { return bounds.width * 0.0556 }
    var cornerYOffset        : CGFloat { return bounds.width * 0.0667 }
    var squareMargin         : CGFloat { return bounds.width * 0.189 }
    var squareStrokeWidth    : CGFloat { return bounds.width * 0.005 }
    var underlineOffset      : CGFloat { return bounds.width * 0.0333 }
    var underlineInset       : CGFloat { return bounds.width * 0.0222 }
    var underlineStrokeWidth : CGFloat { return bounds.width * 0.0111 }

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
        super.prepareForInterfaceBuilder()
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
        
        _ = pushContext()
        UIColor.white.setFill()
        UIRectFill(bounds)
        popContext()
    }
    
    private func drawCenterImage() {
        guard let rookImage = UIImage(named: Card.rookImageName) else {
            return
        }
        
        let width = bounds.width - 2 * centerImageMargin
        let rookImageRect = CGRect(x: centerImageMargin,
                                   y: (bounds.height - width) / 2,
                                   width: width,
                                   height: width)
        
        rookImage.draw(in: rookImageRect)
    }
    
    private func drawCenterSquare() {
        let square = UIBezierPath()
        let width = bounds.width - (2.0 * squareMargin)
        let yOffset = (bounds.height - width) / 2
        
        _ = pushContext()
        suitColor().setStroke()
        square.lineWidth = squareStrokeWidth
        square.move(to: CGPoint(x: squareMargin, y: yOffset))
        square.addLine(to: CGPoint(x: squareMargin + width, y: yOffset))
        square.addLine(to: CGPoint(x: squareMargin + width, y: yOffset + width))
        square.addLine(to: CGPoint(x: squareMargin, y: yOffset + width))
        square.close()
        square.stroke()
        popContext()
    }
    
    private func drawCenterText() {
        let font = rookCardFont(ofSize: centerFontSize)
        let rankText = NSAttributedString(string: "\(rank)", attributes: [
            .font : font,
            .foregroundColor : suitColor()
            ])
        var textBounds = CGRect.zero

        textBounds.size = rankText.size()
        textBounds.origin = CGPoint(x: (bounds.width - textBounds.width) / 2,
                                    y: (bounds.height - textBounds.height) / 2)
        rankText.draw(in: textBounds)

        if Card.underlinedRanks.contains(rank) {
            drawCenterUnderline(using: textBounds, with: font)
        }
    }

    private func drawCenterUnderline(using textBounds: CGRect, with font: UIFont) {
        let underline = UIBezierPath()
        let yOffset = textBounds.origin.y + textBounds.height + font.descender + underlineOffset

        _ = pushContext()
        suitColor().setStroke()
        underline.move(to: CGPoint(x: textBounds.origin.x + underlineInset, y: yOffset))
        underline.addLine(to: CGPoint(x: textBounds.origin.x + textBounds.width - underlineInset,
                                      y: yOffset))
        underline.lineWidth = underlineStrokeWidth
        underline.stroke()
        popContext()
    }

    private func drawCornerText() {
        let rankFont = rookCardFont(ofSize: cornerRankFontSize)
        let suitFont = rookCardFont(ofSize: cornerSuitFontSize)
        let rankText = NSAttributedString(string: "\(rank)", attributes: [
            .font : rankFont,
            .foregroundColor : suitColor()
            ])
        let suitText = NSAttributedString(string: "\(suit)", attributes: [
            .font : suitFont,
            .foregroundColor : suitColor()
            ])

        // NOTE: This y calculation removes the white space above the rank text.
        // (Try using just cornerYOffset as the rankYOffset and you'll see what I mean.)
        let rankYOffset = cornerYOffset - rankFont.lineHeight + rankFont.capHeight -
                          rankFont.descender
        let suitXOffset = cornerXOffset + rankText.size().width + cornerSuitOffset
        let rankOrigin = CGPoint(x: cornerXOffset, y: rankYOffset)
        let suitOrigin = CGPoint(x: suitXOffset, y: cornerYOffset)

        if card.suit == RookCard.Suit.rook {
            if let rookImage = UIImage(named: Card.cornerRookImageName) {
                let rookRect = CGRect(x: cornerXOffset, y: cornerYOffset,
                                      width: cornerImageWidth, height: cornerImageWidth)
                
                rookImage.draw(in: rookRect)
                suitText.draw(at: suitOrigin)
                pushContextAndRotateUpsideDown()
                rookImage.draw(in: rookRect)
                suitText.draw(at: suitOrigin)
                popContext()
            }
        } else {
            rankText.draw(at: rankOrigin)
            suitText.draw(at: suitOrigin)
            pushContextAndRotateUpsideDown()
            rankText.draw(at: rankOrigin)
            suitText.draw(at: suitOrigin)
            popContext()
        }
    }
    
    private func drawFaceDown() {
        UIImage(named: Card.backImageName)?.draw(in: bounds)
    }

    private func drawFaceUp() {
        if card.suit == RookCard.Suit.rook {
            drawCenterImage()
        } else {
            drawCenterText()
            drawCenterSquare()
        }
        
        drawCornerText()
    }
    
    private func popContext() {
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
    
    private func pushContext() -> CGContext? {
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        
        return context
    }
    
    private func pushContextAndRotateUpsideDown() {
        let context = pushContext()
        
        context?.translateBy(x: bounds.width, y: bounds.height)
        context?.rotate(by: CGFloat(Double.pi))
    }
    
    private func rookCardFont(ofSize fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: Card.fontName, size: fontSize) {
            return font
        }
        
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func suitColor() -> UIColor {
        if let color = Card.suitColors[card.suit] {
            return color
        }

        return UIColor.black
    }
}
