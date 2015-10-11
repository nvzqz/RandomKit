//
//  Color+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

private protocol _RKColorType {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
}

extension _RKColorType {
    static func _random(randomAlpha: Bool) -> Self {
        return Self(
            red:   CGFloat.random(),
            green: CGFloat.random(),
            blue:  CGFloat.random(),
            alpha: randomAlpha ? CGFloat.random() : 1.0)
    }
}


#if os(OSX)
import Cocoa

extension NSColor: _RKColorType {
    public static func random(randomAlpha: Bool = false) -> NSColor {
        return _random(randomAlpha)
    }
}


#elseif os(iOS)
import UIKit

extension UIColor: _RKColorType {
    public static func random(randomAlpha: Bool = false) -> UIColor {
        return _random(randomAlpha)
    }
}


#elseif os(watchOS)
import WatchKit

extension UIColor: _RKColorType {
    public static func random(randomAlpha: Bool = false) -> UIColor {
        return _random(randomAlpha)
    }
}

#endif



