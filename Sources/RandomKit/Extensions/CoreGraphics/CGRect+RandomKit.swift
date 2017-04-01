//
//  CGRect+RandomKit.swift
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

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

import CoreGraphics

extension CGRect: Random {

    /// Generates a random `CGRect`.
    ///
    /// - returns: Random value from random `CGPoint` and `CGSize`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> CGRect {
        return CGRect(origin: .random(using: &randomGenerator), size: .random(using: &randomGenerator))
    }

    /// Generates a random `CGRect` in the closed ranges.
    ///
    /// - parameter xRange: The range in which `x` will be generated.
    /// - parameter yRange: The range in which `y` will be generated.
    /// - parameter widthRange: The range in which `width` will be generated.
    /// - parameter heightRange: The range in which `height` will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(xRange: ClosedRange<CGFloat>,
                              yRange:      ClosedRange<CGFloat>,
                              widthRange:  ClosedRange<CGFloat>,
                              heightRange: ClosedRange<CGFloat>,
                              using randomGenerator: inout R) -> CGRect {
        return CGRect(origin: .random(xRange: xRange, yRange: yRange, using: &randomGenerator),
                      size: .random(widthRange: widthRange, heightRange: heightRange, using: &randomGenerator))
    }

}

#endif
