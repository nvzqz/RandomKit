//
//  Float80+RandomKit.swift
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

import Darwin

extension Float80 : RandomType, RandomIntervalType {

    /// Generates a random `Float80`.
    ///
    /// - Returns: Random value within `0.0...1.0`.
    public static func random() -> Float80 {
        return random(0.0...1.0)
    }

    /// Generates a random `Float80` inside of the closed interval.
    ///
    /// - Parameters:
    ///     - interval: The interval within which the number
    ///       will be generated.
    public static func random(_ interval: ClosedRange<Float80>) -> Float80 {
        return interval.lowerBound + (interval.upperBound - interval.lowerBound) * (Float80(arc4random()) / Float80(UInt32.max))
    }

}

#endif
