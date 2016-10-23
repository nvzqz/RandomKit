//
//  CGRect+RandomKit.swift
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

import CoreGraphics

extension CGRect: RandomProtocol {

    /// Generates a random `CGRect`.
    ///
    /// - Returns: Random value from random `CGPoint` and `CGSize`.
    public static func random() -> CGRect {
        return CGRect(origin: .random(), size: .random())
    }

    /// Generates a random `CGRect` within the closed ranges.
    ///
    /// - Parameters:
    ///     - xRange: The range within which `x` will be generated.
    ///     - yRange: The range within which `y` will be generated.
    ///     - widthRange: The range within which `width` will be generated.
    ///     - heightRange: The range within which `height` will be generated.
    public static func random(
        within xRange: ClosedRange<CGFloat.NativeType>,
        _ yRange:      ClosedRange<CGFloat.NativeType>,
        _ widthRange:  ClosedRange<CGFloat.NativeType>,
        _ heightRange: ClosedRange<CGFloat.NativeType>)
    -> CGRect {
        return CGRect(origin: .random(within: xRange, yRange), size: .random(within: widthRange, heightRange))
    }

}
