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

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random(using randomGenerator: RandomGenerator) -> Self {
        var value: Self = 0
        randomGenerator.randomize(value: &value)
        return value
    }

}

extension Integer where Self: RandomToValue & RandomThroughValue {

    /// The random base from which to generate.
    public static var randomBase: Self {
        return 0
    }

}

extension SignedInteger where Self: RandomToValue {

    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random(to value: Self, using randomGenerator: RandomGenerator) -> Self {
        if value == randomBase {
            return value
        } else if value < randomBase {
            var random: Self
            repeat {
                random = self.random(using: randomGenerator)
            } while random > 0
            return random % value
        } else {
            var random: Self
            repeat {
                random = self.random(using: randomGenerator)
            } while random < 0
            return random % value
        }
    }

}

extension UnsignedInteger where Self: RandomToValue {

    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random(to value: Self, using randomGenerator: RandomGenerator) -> Self {
        switch value {
        case randomBase:
            return value
        default:
            return random(using: randomGenerator) % value
        }
    }

}

extension UnsignedInteger where Self: RandomToValue & RandomWithinRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Self>, using randomGenerator: RandomGenerator) -> Self? {
        guard !range.isEmpty else {
            return nil
        }
        return range.lowerBound + random(to: range.upperBound - range.lowerBound, using: randomGenerator)
    }

}

extension SignedInteger where Self: RandomWithMax & RandomWithMin & RandomThroughValue {

    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random(through value: Self, using randomGenerator: RandomGenerator) -> Self {
        if value == randomBase {
            return value
        } else if value < randomBase {
            var random: Self
            repeat {
                random = self.random(using: randomGenerator)
            } while random > 0
            return value == Self.min ? random : (random % (value - 1))
        } else {
            var random: Self
            repeat {
                random = self.random(using: randomGenerator)
            } while random < 0
            return value == Self.max ? random : (random % (value + 1))
        }
    }

}

extension UnsignedInteger where Self: RandomWithMax & RandomThroughValue {

    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random(through value: Self, using randomGenerator: RandomGenerator) -> Self {
        switch value {
        case randomBase:
            return value
        case Self.max:
            return random(using: randomGenerator)
        default:
            return random(using: randomGenerator) % (value + 1)
        }
    }

}

extension UnsignedInteger where Self: RandomThroughValue & RandomWithinClosedRange {

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Self>, using randomGenerator: RandomGenerator) -> Self {
        return closedRange.lowerBound + random(through: closedRange.upperBound - closedRange.lowerBound,
                                               using: randomGenerator)
    }

}

extension Int: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Int>, using randomGenerator: RandomGenerator) -> Int? {
        let lo = UInt(bitPattern: range.lowerBound)._resigned
        let hi = UInt(bitPattern: range.upperBound)._resigned
        guard let random = UInt.random(within: lo..<hi, using: randomGenerator) else {
            return nil
        }
        return Int(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Int>, using randomGenerator: RandomGenerator) -> Int {
        let lo = UInt(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt(bitPattern: closedRange.upperBound)._resigned
        return Int(bitPattern: UInt.random(within: lo...hi, using: randomGenerator)._resigned)
    }

}

extension Int64: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Int64>, using randomGenerator: RandomGenerator) -> Int64? {
        let lo = UInt64(bitPattern: range.lowerBound)._resigned
        let hi = UInt64(bitPattern: range.upperBound)._resigned
        guard let random = UInt64.random(within: lo..<hi, using: randomGenerator) else {
            return nil
        }
        return Int64(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Int64>, using randomGenerator: RandomGenerator) -> Int64 {
        let lo = UInt64(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt64(bitPattern: closedRange.upperBound)._resigned
        return Int64(bitPattern: UInt64.random(within: lo...hi, using: randomGenerator)._resigned)
    }

}

extension Int32: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Int32>, using randomGenerator: RandomGenerator) -> Int32? {
        let lo = UInt32(bitPattern: range.lowerBound)._resigned
        let hi = UInt32(bitPattern: range.upperBound)._resigned
        guard let random = UInt32.random(within: lo..<hi, using: randomGenerator) else {
            return nil
        }
        return Int32(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Int32>, using randomGenerator: RandomGenerator) -> Int32 {
        let lo = UInt32(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt32(bitPattern: closedRange.upperBound)._resigned
        return Int32(bitPattern: UInt32.random(within: lo...hi, using: randomGenerator)._resigned)
    }

}

extension Int16: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Int16>, using randomGenerator: RandomGenerator) -> Int16? {
        let lo = UInt16(bitPattern: range.lowerBound)._resigned
        let hi = UInt16(bitPattern: range.upperBound)._resigned
        guard let random = UInt16.random(within: lo..<hi, using: randomGenerator) else {
            return nil
        }
        return Int16(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Int16>, using randomGenerator: RandomGenerator) -> Int16 {
        let lo = UInt16(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt16(bitPattern: closedRange.upperBound)._resigned
        return Int16(bitPattern: UInt16.random(within: lo...hi, using: randomGenerator)._resigned)
    }

}

extension Int8: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Int8>, using randomGenerator: RandomGenerator) -> Int8? {
        let lo = UInt8(bitPattern: range.lowerBound)._resigned
        let hi = UInt8(bitPattern: range.upperBound)._resigned
        guard let random = UInt8.random(within: lo..<hi, using: randomGenerator) else {
            return nil
        }
        return Int8(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Int8>, using randomGenerator: RandomGenerator) -> Int8 {
        let lo = UInt8(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt8(bitPattern: closedRange.upperBound)._resigned
        return Int8(bitPattern: UInt8.random(within: lo...hi, using: randomGenerator)._resigned)
    }

}

extension UInt: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    fileprivate var _resigned: UInt {
        return UInt(UIntMax(self)._resigned)
    }

}

extension UInt64: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    fileprivate var _resigned: UInt64 {
        return self ^ (1 << 63)
    }

}

extension UInt32: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    fileprivate var _resigned: UInt32 {
        return self ^ (1 << 31)
    }

}

extension UInt16: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    fileprivate var _resigned: UInt16 {
        return self ^ (1 << 15)
    }

}

extension UInt8: RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    fileprivate var _resigned: UInt8 {
        return self ^ (1 << 7)
    }

}

// MARK: Implement DiscreteRandomDistribuable
extension Int: DiscreteRandomDistribuable {
    public static var bernoulliValues: (Int, Int) { return (0, 1) }
}
