//
//  CGPoint+RandomKit.swift
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

import CoreGraphics

extension CGPoint: RandomType {

    /// Generates a random `CGPoint`.
    ///
    /// - Returns: Random value within `0.0...1.0` for both `x` and `y`.
    public static func random() -> CGPoint {
        return random(0.0...1.0, 0.0...1.0)
    }

    /// Generates a random `CGPoint` inside of the closed intervals.
    ///
    /// - Parameters:
    ///     - xInterval: The interval within which the `x` value will be generated.
    ///     - yInterval: The interval within which the `y` value will be generated.
    public static func random(xInterval: ClosedInterval<CGFloat.NativeType>, _ yInterval: ClosedInterval<CGFloat.NativeType>) -> CGPoint {
        return CGPoint(x: CGFloat.random(xInterval), y: CGFloat.random(yInterval))
    }

}
