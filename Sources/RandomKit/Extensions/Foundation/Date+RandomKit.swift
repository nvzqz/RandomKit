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

extension Date: Random, RandomInRange, RandomInClosedRange {

    /// Generates a random date.
    ///
    /// - returns: Random date in `Date.distantPast...Date.distantFuture`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Date {
        return random(in: .distantPast ... .distantFuture, using: &randomGenerator)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    ///
    /// - parameter range: The range in which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Date>, using randomGenerator: inout R) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let range = Range(uncheckedBounds: (lower, upper))
        let value = TimeInterval.uncheckedRandom(in: range, using: &randomGenerator)
        return Date(timeIntervalSinceReferenceDate: value)
    }

    /// Returns a random value of `Self` inside of the closed range using `randomGenerator`.
    ///
    /// - parameter closedRange: The range in which the date will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Date>, using randomGenerator: inout R) -> Date {
        let lower = closedRange.lowerBound.timeIntervalSinceReferenceDate
        let upper = closedRange.upperBound.timeIntervalSinceReferenceDate
        let range = ClosedRange(uncheckedBounds: (lower, upper))
        let value = TimeInterval.random(in: range, using: &randomGenerator)
        return Date(timeIntervalSinceReferenceDate: value)
    }

}
