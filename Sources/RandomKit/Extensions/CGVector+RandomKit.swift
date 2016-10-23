//
//  CGVector+RandomKit.swift
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

extension CGVector: RandomType {

    /// Generates a random `CGVector`.
    ///
    /// - Returns: Random value within `0...100` for both `dx` and `dy`.
    public static func random() -> CGVector {
        return random(0...100, 0...100)
    }

    /// Generates a random `CGVector` inside of the closed intervals.
    ///
    /// - Parameters:
    ///     - dxInterval: The interval within which `dx` will be generated.
    ///     - dyInterval: The interval within which `dy` will be generated.
    public static func random(_ dxInterval: ClosedRange<CGFloat.NativeType>, _ dyInterval: ClosedRange<CGFloat.NativeType>) -> CGVector {
        let rx = CGFloat.NativeType.random(dxInterval)
        let ry = CGFloat.NativeType.random(dyInterval)
        return CGVector(dx: CGFloat(rx), dy: CGFloat(ry))
    }

}
