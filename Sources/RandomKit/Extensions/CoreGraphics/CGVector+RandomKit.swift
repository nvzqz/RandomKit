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

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import CoreGraphics

extension CGVector: Random {

    /// Generates a random `CGVector`.
    ///
    /// - Returns: Random value within `0...100` for both `dx` and `dy`.
    public static func random() -> CGVector {
        return random(within: 0...100, 0...100)
    }

    /// Generates a random `CGVector` within the closed ranges.
    ///
    /// - parameter dxRange: The range within which `dx` will be generated.
    /// - parameter dyRange: The range within which `dy` will be generated.
    public static func random(within dxRange: ClosedRange<CGFloat.NativeType>,
                              _ dyRange: ClosedRange<CGFloat.NativeType>) -> CGVector {
        let rx = CGFloat.NativeType.random(within: dxRange)
        let ry = CGFloat.NativeType.random(within: dyRange)
        return CGVector(dx: CGFloat(rx), dy: CGFloat(ry))
    }

}

#endif
