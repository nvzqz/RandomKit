//
//  Color+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2017 Nikolai Vazquez
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

#if os(macOS)
import Cocoa

extension NSColor: Random {

    /// Generates a random color.
    ///
    /// - returns: Random color without random alpha.
    public class func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return random(alpha: false, using: &randomGenerator)
    }

    /// Generates a random color.
    ///
    /// - parameter alpha: If `true`, the alpha value will be random. If `false`, the alpha value will be `1.0`.
    public class func random<R: RandomGenerator>(alpha: Bool, using randomGenerator: inout R) -> Self {
        return self.init(red:   CGFloat.random(using: &randomGenerator),
                         green: CGFloat.random(using: &randomGenerator),
                         blue:  CGFloat.random(using: &randomGenerator),
                         alpha: alpha ? CGFloat.random(using: &randomGenerator) : 1.0)
    }

}

#elseif os(iOS) || os(tvOS)
import UIKit

#elseif os(watchOS)
import WatchKit

#endif

#if os(iOS) || os(tvOS) || os(watchOS)
extension UIColor: Random {

    /// Generates a random color.
    ///
    /// - returns: Random color without random alpha.
    public class func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return random(alpha: false, using: &randomGenerator)
    }

    /// Generates a random color.
    ///
    /// - parameter alpha: If `true`, the alpha value will be random. If `false`, the alpha value will be `1.0`.
    public class func random<R: RandomGenerator>(alpha: Bool, using randomGenerator: inout R) -> Self {
        return self.init(red:   CGFloat.random(using: &randomGenerator),
                         green: CGFloat.random(using: &randomGenerator),
                         blue:  CGFloat.random(using: &randomGenerator),
                         alpha: alpha ? CGFloat.random(using: &randomGenerator) : 1.0)
    }

}
#endif
