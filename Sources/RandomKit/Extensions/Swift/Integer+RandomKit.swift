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
import ShiftOperations

extension ExpressibleByIntegerLiteral where Self: UnsafeRandom {

    /// The base randomizable value for `Self`. Always zero.
    public static var randomizableValue: Self {
        return 0
    }

}

extension Integer where Self: RandomToValue & RandomThroughValue {

    /// The random base from which to generate.
    public static var randomBase: Self {
        return 0
    }

}

private extension Integer where Self: RandomWithMax {

    @inline(__always)
    static func _randomGreater(to value: Self, using randomGenerator: RandomGenerator) -> Self {
        var result: Self
        repeat {
            result = random(using: randomGenerator)
        } while result < max % value
        return result % value
    }

}

private extension Integer where Self: RandomWithMin {

    @inline(__always)
    static func _randomLess(to value: Self, using randomGenerator: RandomGenerator) -> Self {
        var result: Self
        repeat {
            result = random(using: randomGenerator)
        } while result > min % value
        return result % value
    }

}

extension SignedInteger where Self: RandomWithMax & RandomWithMin & RandomToValue & RandomThroughValue {

    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random(to value: Self, using randomGenerator: RandomGenerator) -> Self {
        if value == randomBase {
            return value
        } else if value < randomBase {
            return _randomLess(to: value, using: randomGenerator)
        } else {
            return _randomGreater(to: value, using: randomGenerator)
        }
    }

    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random(through value: Self, using randomGenerator: RandomGenerator) -> Self {
        switch value {
        case randomBase:
            return value
        case min:
            var result: Self
            repeat {
                result = random(using: randomGenerator)
            } while result > 0
            return result
        case max:
            var result: Self
            repeat {
                result = random(using: randomGenerator)
            } while result < 0
            return result
        default:
            if value < randomBase {
                return _randomLess(to: value &- 1, using: randomGenerator)
            } else {
                return _randomGreater(to: value &+ 1, using: randomGenerator)
            }
        }
    }

}

extension UnsignedInteger where Self: Random & RandomToValue & RandomWithMax {

    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random(to value: Self, using randomGenerator: RandomGenerator) -> Self {
        switch value {
        case randomBase:
            return value
        default:
            return _randomGreater(to: value, using: randomGenerator)
        }
    }

}

extension UnsignedInteger where Self: RandomToValue & RandomWithinRange {

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<Self>, using randomGenerator: RandomGenerator) -> Self? {
        guard !range.isEmpty else {
            return nil
        }
        return range.lowerBound &+ random(to: range.upperBound &- range.lowerBound, using: randomGenerator)
    }

}

extension UnsignedInteger where Self: RandomWithMax & RandomThroughValue {

    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random(through value: Self, using randomGenerator: RandomGenerator) -> Self {
        switch value {
        case randomBase:
            return value
        case max:
            return random(using: randomGenerator)
        default:
            return _randomGreater(to: value &+ 1, using: randomGenerator)
        }
    }

}

extension UnsignedInteger where Self: RandomThroughValue & RandomWithinClosedRange {

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Self>, using randomGenerator: RandomGenerator) -> Self {
        return closedRange.lowerBound &+ random(through: closedRange.upperBound &- closedRange.lowerBound,
                                                using: randomGenerator)
    }

}

extension UnsignedInteger where Self: ShiftOperations & RandomWithMax & RandomWithMaxWidth {

    /// Generates a random value of `Self` with a maximum width using `randomGenerator`.
    public static func random(withMaxWidth width: Int, using randomGenerator: RandomGenerator) -> Self {
        guard width > 0 else {
            return 0
        }

        let result = random(using: randomGenerator)
        let typeWidth = MemoryLayout<Self>.size * 8

        if width > typeWidth {
            return result
        } else {
            if (width % typeWidth) != 0 {
                return result & (max >> Self(UIntMax(typeWidth - width)))
            } else {
                return result
            }
        }
    }

}

extension UnsignedInteger where Self: ShiftOperations & RandomWithMaxWidth & RandomWithExactWidth {

    /// Generates a random value of `Self` with an exact width using `randomGenerator`.
    public static func random(withExactWidth width: Int, using randomGenerator: RandomGenerator) -> Self {
        guard width > 0 else {
            return 0
        }
        return random(withMaxWidth: width, using: randomGenerator) | (1 << Self(UIntMax(width - 1)))
    }

}

extension Int: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

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

extension Int64: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

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

extension Int32: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

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

extension Int16: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

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

extension Int8: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

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

extension UInt: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    private static let _mostSignificantBit: UInt = 1 << UInt((MemoryLayout<UInt>.size * 8) - 1)

    fileprivate var _resigned: UInt {
        return self ^ ._mostSignificantBit
    }

}

extension UInt64: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    fileprivate var _resigned: UInt64 {
        return self ^ (1 << 63)
    }

}

extension UInt32: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    fileprivate var _resigned: UInt32 {
        return self ^ (1 << 31)
    }

}

extension UInt16: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    fileprivate var _resigned: UInt16 {
        return self ^ (1 << 15)
    }

}

extension UInt8: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    fileprivate var _resigned: UInt8 {
        return self ^ (1 << 7)
    }

}
