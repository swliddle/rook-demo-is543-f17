//
//  UIColor+rgb.swift
//  Rook Card Demo
//
//  Created by Steve Liddle on 10/8/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0,
                  alpha: 1.0)
    }
}
