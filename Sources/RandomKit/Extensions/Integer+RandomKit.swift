//
//  Integer+RandomKit.swift
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

import Foundation

extension Integer where Self: Random {

    /// Generates a random value of `Self`.
    public static func random() -> Self {
        var value: Self = 0
        arc4random_buf(&value, MemoryLayout<Self>.size)
        return value
    }

}

extension Int : Random, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Int>) -> Int? {
        guard range.lowerBound != range.upperBound else {
            return nil
        }
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Int>) -> Int {
        let value = Int(arc4random_uniform(UInt32(closedRange.upperBound - closedRange.lowerBound + 1)))
        return closedRange.lowerBound + value
    }

}

extension UInt32: Random, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<UInt32>) -> UInt32? {
        guard range.lowerBound != range.upperBound else {
            return nil
        }
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<UInt32>) -> UInt32 {
        let range = Range(uncheckedBounds: (closedRange.lowerBound, closedRange.upperBound))
        guard let value = random(within: range) else {
            return closedRange.lowerBound
        }
        return Bool.random() ? value : value + 1
    }

}
