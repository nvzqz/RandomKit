//
//  NSDate+RandomKit.swift
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

import Foundation

extension Date: Random, RandomWithinRange, RandomWithinClosedRange {

    /// Generates a random date.
    ///
    /// - returns: Random date within `Date.distantPast...Date.distantFuture`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Date {
        return random(within: .distantPast ... .distantFuture, using: &randomGenerator)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    ///
    /// - parameter range: The range within which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func uncheckedRandom<R: RandomGenerator>(within range: Range<Date>, using randomGenerator: inout R) -> Date {
        let lower = range.lowerBound.timeIntervalSince1970
        let upper = range.upperBound.timeIntervalSince1970
        let range = Range(uncheckedBounds: (lower, upper))
        return Date(timeIntervalSince1970: TimeInterval.uncheckedRandom(within: range, using: &randomGenerator))
    }

    /// Returns a random value of `Self` inside of the closed range using `randomGenerator`.
    ///
    /// - parameter closedRange: The range within which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(within closedRange: ClosedRange<Date>, using randomGenerator: inout R) -> Date {
        let lower = closedRange.lowerBound.timeIntervalSince1970
        let upper = closedRange.upperBound.timeIntervalSince1970
        return random(within: ClosedRange(uncheckedBounds: (lower, upper)), using: &randomGenerator)
    }

    /// Generates a random date within the range.
    ///
    /// - parameter range: The range within which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(within range: Range<TimeInterval>, using randomGenerator: inout R) -> Date? {
        guard let random = TimeInterval.random(within: range, using: &randomGenerator) else {
            return nil
        }
        return Date(timeIntervalSince1970: random)
    }

    /// Generates a random date within the closed range.
    ///
    /// - parameter closedRange: The range within which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(within closedRange: ClosedRange<TimeInterval>, using randomGenerator: inout R) -> Date {
        return Date(timeIntervalSince1970: .random(within: closedRange, using: &randomGenerator))
    }

}
