//
//  UnicodeScalar+RandomKit.swift
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

extension UnicodeScalar: Random, RandomWithinRange, RandomWithinClosedRange {

    /// A unicode scalar range from `" "` through `"~"`.
    public static let randomRange: ClosedRange<UnicodeScalar> = " "..."~"

    /// Generates a random value of `Self`.
    ///
    /// The random value is within `UnicodeScalar.randomRange`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> UnicodeScalar {
        return random(within: UnicodeScalar.randomRange, using: &randomGenerator)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func uncheckedRandom<R: RandomGenerator>(within range: Range<UnicodeScalar>, using randomGenerator: inout R) -> UnicodeScalar {
        let lower = range.lowerBound.value
        let upper = range.upperBound.value
        if lower._isLowerRange && !upper._isLowerRange {
            let diff: UInt32 = 0xE000 - 0xD7FF - 1
            let newRange = Range(uncheckedBounds: (lower, upper - diff))
            let random = UInt32.uncheckedRandom(within: newRange, using: &randomGenerator)
            if random._isLowerRange {
                return unsafeBitCast(random, to: UnicodeScalar.self)
            } else {
                return unsafeBitCast(random &+ diff, to: UnicodeScalar.self)
            }
        } else {
            let newRange = Range(uncheckedBounds: (lower, upper))
            let random = UInt32.uncheckedRandom(within: newRange, using: &randomGenerator)
            return unsafeBitCast(random, to: UnicodeScalar.self)
        }
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(within closedRange: ClosedRange<UnicodeScalar>,
                                                  using randomGenerator: inout R) -> UnicodeScalar {
        let lower = closedRange.lowerBound.value
        let upper = closedRange.upperBound.value
        if lower._isLowerRange && !upper._isLowerRange {
            let diff: UInt32 = 0xE000 - 0xD7FF - 1
            let newRange = ClosedRange(uncheckedBounds: (lower, upper - diff))
            let random = UInt32.random(within: newRange, using: &randomGenerator)
            if random._isLowerRange {
                return unsafeBitCast(random, to: UnicodeScalar.self)
            } else {
                return unsafeBitCast(random &+ diff, to: UnicodeScalar.self)
            }
        } else {
            let newRange = ClosedRange(uncheckedBounds: (lower, upper))
            let random = UInt32.random(within: newRange, using: &randomGenerator)
            return unsafeBitCast(random, to: UnicodeScalar.self)
        }
    }

    /// Returns an optional random value of `Self` inside of the range.
    public static func random<R: RandomGenerator>(within range: Range<UInt8>,
                                                  using randomGenerator: inout R) -> UnicodeScalar? {
        return UInt8.random(within: range, using: &randomGenerator).map(UnicodeScalar.init)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(within closedRange: ClosedRange<UInt8>,
                                                  using randomGenerator: inout R) -> UnicodeScalar {
        return UnicodeScalar(UInt8.random(within: closedRange, using: &randomGenerator))
    }

}

private extension UInt32 {

    var _isLowerRange: Bool {
        return self <= 0xD7FF
    }

}
