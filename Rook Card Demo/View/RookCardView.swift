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
        static let cornerRookImageName = "RookSquareTurquoise"
        static let fontName = "Palatino-Bold"
        static let rookImageName = "RookSquare"
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
    var suit = Suit.rook
    
    // MARK: - Computed properties
    
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
    var underlineInset       : CGFloat { return bounds.width * 0.0111 }
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
            drawCenterUnderline(using: textBounds, with: font)
        }
    }
    
    private func drawCenterUnderline(using textBounds: CGRect, with font: UIFont) {
        let underline = UIBezierPath()
        let yOffset = textBounds.origin.y + textBounds.height + font.descender + underlineOffset
        
        underline.move(to: CGPoint(x: textBounds.origin.x + underlineInset, y: yOffset))
        underline.addLine(to: CGPoint(x: textBounds.origin.x + textBounds.width - 2 * underlineInset,
                                      y: yOffset))
        underline.lineWidth = underlineStrokeWidth
        underline.stroke()
    }

    private func drawCornerText() {
        guard let rankFont = UIFont(name: Card.fontName, size: cornerRankFontSize) else {
            return
        }
        
        guard let suitFont = UIFont(name: Card.fontName, size: cornerSuitFontSize) else {
            return
        }

        guard let color = Card.suitColors[suit] else {
            return
        }

        let rankText = NSAttributedString(string: "\(rank)", attributes: [
            .font : rankFont,
            .foregroundColor : color
            ])
        let suitText = NSAttributedString(string: "\(suit.rawValue.uppercased())", attributes: [
            .font : suitFont,
            .foregroundColor : color
            ])
        let rankOrigin = CGPoint(x: cornerXOffset,
                                 y: cornerYOffset - rankFont.lineHeight + rankFont.capHeight
                                    - rankFont.descender)
        let suitOrigin = CGPoint(x: cornerXOffset + rankText.size().width + cornerSuitOffset,
                                 y: cornerYOffset)
        
        if suit == Suit.rook {
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
}
