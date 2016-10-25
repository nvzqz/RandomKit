//
//  UnicodeScalar+RandomKit.swift
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

extension UnicodeScalar: Random, RandomWithinRange, RandomWithinClosedRange {

    /// Generates a random value of `Self`.
    ///
    /// The random value is within `32...126`, or `" "..."~"`.
    public static func random(using randomGenerator: RandomGenerator) -> UnicodeScalar {
        return random(within: 32...126, using: randomGenerator)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within range: Range<UnicodeScalar>,
                              using randomGenerator: RandomGenerator) -> UnicodeScalar? {
        guard range.lowerBound != range.upperBound else {
            return nil
        }
        let lower = range.lowerBound.value
        let upper = range.upperBound.value
        if lower._isLowerRange && !upper._isLowerRange {
            if Bool.random(), let value = UInt32.random(within: 0xE000 ..< upper, using: randomGenerator) {
                return UnicodeScalar(value)
            } else {
                return UnicodeScalar(UInt32.random(within: lower ... 0xD7FF, using: randomGenerator))
            }
        } else {
            return UInt32.random(within: lower ..< upper, using: randomGenerator).flatMap(UnicodeScalar.init)
        }
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<UnicodeScalar>,
                              using randomGenerator: RandomGenerator) -> UnicodeScalar {
        let lower = closedRange.lowerBound.value
        let upper = closedRange.upperBound.value
        let range: ClosedRange<UInt32>
        if lower._isLowerRange && !upper._isLowerRange {
            range = Bool.random(using: randomGenerator) ? lower...0xD7FF : 0xE000...upper
        } else {
            range = lower...upper
        }
        return UnicodeScalar(.random(within: range, using: randomGenerator))!
    }

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<UInt8>,
                              using randomGenerator: RandomGenerator = .default) -> UnicodeScalar? {
        return UInt8.random(within: range, using: randomGenerator).map(UnicodeScalar.init)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<UInt8>,
                              using randomGenerator: RandomGenerator = .default) -> UnicodeScalar {
        return UnicodeScalar(UInt8.random(within: closedRange))
    }

}

private extension UInt32 {

    var _isLowerRange: Bool {
        return 0...0xD7FF ~= self
    }

}
