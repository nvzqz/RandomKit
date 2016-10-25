//
//  NSDate+RandomKit.swift
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

extension Date: Random, RandomWithinClosedRange {

    /// Generates a random date.
    ///
    /// - returns: Random date within `0.0...TimeInterval(UInt32.max)`.
    public static func random(using randomGenerator: RandomGenerator) -> Date {
        return random(within: 0.0...TimeInterval(UInt32.max), using: randomGenerator)
    }

    /// Returns a random value of `Self` inside of the closed range using `randomGenerator`.
    ///
    /// - parameter closedRange: The range within which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random(within closedRange: ClosedRange<Date>, using randomGenerator: RandomGenerator) -> Date {
        let lower = closedRange.lowerBound.timeIntervalSince1970
        let upper = closedRange.upperBound.timeIntervalSince1970
        return random(within: lower...upper, using: randomGenerator)
    }

    /// Generates a random date within the closed range.
    ///
    /// - parameter closedRange: The range within which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random(within closedRange: ClosedRange<TimeInterval>,
                              using randomGenerator: RandomGenerator = .default) -> Date {
        return Date(timeIntervalSince1970: .random(within: closedRange, using: randomGenerator))
    }

}
