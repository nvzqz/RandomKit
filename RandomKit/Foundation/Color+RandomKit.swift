//
//  Color+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
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

#if os(OSX)
import Cocoa

extension NSColor: RandomType {

    /// Generates a random color.
    ///
    /// - Returns: Random color without random alpha.
    public class func random() -> Self {
        return random(alpha: false)
    }

    /// Generates a random color.
    ///
    /// - Parameters:
    ///     - alpha: If `true`, the alpha value will be random.
    ///              If `false`, the alpha value will be `1.0`.
    public class func random(alpha flag: Bool) -> Self {
        return self.init(
            red:   CGFloat.random(),
            green: CGFloat.random(),
            blue:  CGFloat.random(),
            alpha: flag ? CGFloat.random() : 1.0)
    }

}

#elseif os(iOS)
import UIKit

#elseif os(watchOS)
import WatchKit

#endif


#if os(iOS) || os(watchOS)
extension UIColor: RandomType {

    /// Generates a random color.
    ///
    /// - Returns: Random color without random alpha.
    public class func random() -> Self {
        return random(alpha: false)
    }

    /// Generates a random color.
    ///
    /// - Parameters:
    ///     - alpha: If `true`, the alpha value will be random.
    ///              If `false`, the alpha value will be `1.0`.
    public class func random(alpha flag: Bool) -> Self {
        return self.init(
            red:   CGFloat.random(),
            green: CGFloat.random(),
            blue:  CGFloat.random(),
            alpha: flag ? CGFloat.random() : 1.0)
    }

}
#endif



