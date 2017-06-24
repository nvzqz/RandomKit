//
//  Integer+RandomKit.swift
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

// The '>>' and '<<' operators are covered by FixedWidthInteger
#if !swift(>=3.2)
import ShiftOperations
#endif

extension ExpressibleByIntegerLiteral where Self: UnsafeRandom {

    /// The base randomizable value for `Self`. Always zero.
    public static var randomizableValue: Self {
        return 0
    }

}

extension ExpressibleByIntegerLiteral where Self: RandomToValue & RandomThroughValue {

    /// The random base from which to generate.
    public static var randomBase: Self {
        return 0
    }

}

#if swift(>=3.2)

private extension FixedWidthInteger where Self: Random {

    @inline(__always)
    static func _randomGreater<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        var result: Self
        repeat {
            result = random(using: &randomGenerator)
        } while result < max % value
        return result % value
    }

    @inline(__always)
    static func _randomLess<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        var result: Self
        repeat {
            result = random(using: &randomGenerator)
        } while result > min % value
        return result % value
    }

}

#else

private extension Integer where Self: RandomWithMax {

    @inline(__always)
    static func _randomGreater<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        var result: Self
        repeat {
            result = random(using: &randomGenerator)
        } while result < max % value
        return result % value
    }

}

private extension Integer where Self: RandomWithMin {

    @inline(__always)
    static func _randomLess<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        var result: Self
        repeat {
            result = random(using: &randomGenerator)
        } while result > min % value
        return result % value
    }

}

#endif

#if swift(>=3.2)

extension SignedInteger where Self: FixedWidthInteger & Random & RandomToValue & RandomThroughValue {

    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        if value == randomBase {
            return value
        } else if value < randomBase {
            return _randomLess(to: value, using: &randomGenerator)
        } else {
            return _randomGreater(to: value, using: &randomGenerator)
        }
    }

    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random<R: RandomGenerator>(through value: Self, using randomGenerator: inout R) -> Self {
        switch value {
        case randomBase:
            return value
        case min:
            var result: Self
            repeat {
                result = random(using: &randomGenerator)
            } while result > 0
            return result
        case max:
            var result: Self
            repeat {
                result = random(using: &randomGenerator)
            } while result < 0
            return result
        default:
            if value < randomBase {
                return _randomLess(to: value &- 1, using: &randomGenerator)
            } else {
                return _randomGreater(to: value &+ 1, using: &randomGenerator)
            }
        }
    }

}

#else

extension SignedInteger where Self: RandomWithMax & RandomWithMin & RandomToValue & RandomThroughValue {

    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        if value == randomBase {
            return value
        } else if value < randomBase {
            return _randomLess(to: value, using: &randomGenerator)
        } else {
            return _randomGreater(to: value, using: &randomGenerator)
        }
    }

    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random<R: RandomGenerator>(through value: Self, using randomGenerator: inout R) -> Self {
        switch value {
        case randomBase:
            return value
        case min:
            var result: Self
            repeat {
                result = random(using: &randomGenerator)
            } while result > 0
            return result
        case max:
            var result: Self
            repeat {
                result = random(using: &randomGenerator)
            } while result < 0
            return result
        default:
            if value < randomBase {
                return _randomLess(to: value &- 1, using: &randomGenerator)
            } else {
                return _randomGreater(to: value &+ 1, using: &randomGenerator)
            }
        }
    }

}

#endif

#if swift(>=3.2)

extension UnsignedInteger where Self: FixedWidthInteger & Random & RandomToValue {
    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        switch value {
        case 0:
            return value
        default:
            return _randomGreater(to: value, using: &randomGenerator)
        }
    }
}

#else

extension UnsignedInteger where Self: Random & RandomToValue & RandomWithMax {
    /// Generates a random value of `Self` from `randomBase` to `value`.
    public static func random<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        switch value {
        case randomBase:
            return value
        default:
            return _randomGreater(to: value, using: &randomGenerator)
        }
    }
}

#endif

#if swift(>=3.2)

extension UnsignedInteger where Self: FixedWidthInteger & RandomToValue & RandomInRange {
    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Self>, using randomGenerator: inout R) -> Self {
        return range.lowerBound &+ random(to: range.upperBound &- range.lowerBound, using: &randomGenerator)
    }
}

#else

extension UnsignedInteger where Self: RandomToValue & RandomInRange {
    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Self>, using randomGenerator: inout R) -> Self {
        return range.lowerBound &+ random(to: range.upperBound &- range.lowerBound, using: &randomGenerator)
    }
}

#endif

#if swift(>=3.2)

extension UnsignedInteger where Self: FixedWidthInteger & Random & RandomThroughValue {
    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random<R: RandomGenerator>(through value: Self, using randomGenerator: inout R) -> Self {
        switch value {
        case randomBase:
            return value
        case max:
            return random(using: &randomGenerator)
        default:
            return _randomGreater(to: value &+ 1, using: &randomGenerator)
        }
    }
}

#else

extension UnsignedInteger where Self: RandomWithMax & RandomThroughValue {
    /// Generates a random value of `Self` from `randomBase` through `value`.
    public static func random<R: RandomGenerator>(through value: Self, using randomGenerator: inout R) -> Self {
        switch value {
        case randomBase:
            return value
        case max:
            return random(using: &randomGenerator)
        default:
            return _randomGreater(to: value &+ 1, using: &randomGenerator)
        }
    }
}

#endif

#if swift(>=3.2)

extension UnsignedInteger where Self: FixedWidthInteger & RandomThroughValue & RandomInClosedRange {
    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> Self {
        let bound = closedRange.upperBound &- closedRange.lowerBound
        let value = random(through: bound, using: &randomGenerator)
        return closedRange.lowerBound &+ value
    }
}

#else

extension UnsignedInteger where Self: RandomThroughValue & RandomInClosedRange {
    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> Self {
        let bound = closedRange.upperBound &- closedRange.lowerBound
        let value = random(through: bound, using: &randomGenerator)
        return closedRange.lowerBound &+ value
    }
}

#endif

#if swift(>=3.2)

extension UnsignedInteger where Self: FixedWidthInteger & Random & RandomWithMaxWidth {

    /// Generates a random value of `Self` with a maximum width using `randomGenerator`.
    public static func random<R: RandomGenerator>(withMaxWidth width: Int, using randomGenerator: inout R) -> Self {
        guard width > 0 else {
            return 0
        }

        let result = random(using: &randomGenerator)
        let typeWidth = MemoryLayout<Self>.size * 8

        if width > typeWidth {
            return result
        } else {
            if (width % typeWidth) != 0 {
                return result & (max &>> Self(typeWidth - width))
            } else {
                return result
            }
        }
    }
    
}

#else

extension UnsignedInteger where Self: ShiftOperations & RandomWithMax & RandomWithMaxWidth {
    /// Generates a random value of `Self` with a maximum width using `randomGenerator`.
    public static func random<R: RandomGenerator>(withMaxWidth width: Int, using randomGenerator: inout R) -> Self {
        guard width > 0 else {
            return 0
        }

        let result = random(using: &randomGenerator)
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

#endif

#if swift(>=3.2)

extension UnsignedInteger where Self: RandomWithMaxWidth & RandomWithExactWidth {
    /// Generates a random value of `Self` with an exact width using `randomGenerator`.
    public static func random<R: RandomGenerator>(withExactWidth width: Int, using randomGenerator: inout R) -> Self {
        guard width > 0 else { return 0 }
        return random(withMaxWidth: width, using: &randomGenerator) | (1 &<< Self(width - 1))
    }
}

#else

extension UnsignedInteger where Self: ShiftOperations & RandomWithMaxWidth & RandomWithExactWidth {
    /// Generates a random value of `Self` with an exact width using `randomGenerator`.
    public static func random<R: RandomGenerator>(withExactWidth width: Int, using randomGenerator: inout R) -> Self {
        guard width > 0 else { return 0 }
        return random(withMaxWidth: width, using: &randomGenerator) | (1 << Self(UIntMax(width - 1)))
    }
}

#endif

extension Int: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    @inline(__always)
    private static func _resignedRange(from range: Range<Int>) -> Range<UInt> {
        let lo = UInt(bitPattern: range.lowerBound)._resigned
        let hi = UInt(bitPattern: range.upperBound)._resigned
        return Range(uncheckedBounds: (lo, hi))
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Int {
        return Int(bitPattern: UInt.random(using: &randomGenerator))
    }

    /// Returns an optional random value of `Self` inside of the range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Int? {
        guard let random = UInt.random(in: _resignedRange(from: range), using: &randomGenerator) else {
            return nil
        }
        return Int(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Int {
        let random = UInt.uncheckedRandom(in: _resignedRange(from: range), using: &randomGenerator)
        return Int(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Int>, using randomGenerator: inout R) -> Int {
        let lo = UInt(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt(bitPattern: closedRange.upperBound)._resigned
        let closedRange = ClosedRange(uncheckedBounds: (lo, hi))
        return Int(bitPattern: UInt.random(in: closedRange, using: &randomGenerator)._resigned)
    }

}

extension Int64: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    @inline(__always)
    private static func _resignedRange(from range: Range<Int64>) -> Range<UInt64> {
        let lo = UInt64(bitPattern: range.lowerBound)._resigned
        let hi = UInt64(bitPattern: range.upperBound)._resigned
        return Range(uncheckedBounds: (lo, hi))
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Int64 {
        return Int64(bitPattern: UInt64.random(using: &randomGenerator))
    }

    /// Returns an optional random value of `Self` inside of the range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in range: Range<Int64>, using randomGenerator: inout R) -> Int64? {
        guard let random = UInt64.random(in: _resignedRange(from: range), using: &randomGenerator) else {
            return nil
        }
        return Int64(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Int64>, using randomGenerator: inout R) -> Int64 {
        let lo = UInt64(bitPattern: range.lowerBound)._resigned
        let hi = UInt64(bitPattern: range.upperBound)._resigned
        let range = Range(uncheckedBounds: (lo, hi))
        let random = UInt64.uncheckedRandom(in: range, using: &randomGenerator)
        return Int64(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Int64>, using randomGenerator: inout R) -> Int64 {
        let lo = UInt64(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt64(bitPattern: closedRange.upperBound)._resigned
        let closedRange = ClosedRange(uncheckedBounds: (lo, hi))
        return Int64(bitPattern: UInt64.random(in: closedRange, using: &randomGenerator)._resigned)
    }

}

extension Int32: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    @inline(__always)
    private static func _resignedRange(from range: Range<Int32>) -> Range<UInt32> {
        let lo = UInt32(bitPattern: range.lowerBound)._resigned
        let hi = UInt32(bitPattern: range.upperBound)._resigned
        return Range(uncheckedBounds: (lo, hi))
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Int32 {
        return Int32(bitPattern: UInt32.random(using: &randomGenerator))
    }

    /// Returns an optional random value of `Self` inside of the range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in range: Range<Int32>, using randomGenerator: inout R) -> Int32? {
        guard let random = UInt32.random(in: _resignedRange(from: range), using: &randomGenerator) else {
            return nil
        }
        return Int32(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Int32>, using randomGenerator: inout R) -> Int32 {
        let lo = UInt32(bitPattern: range.lowerBound)._resigned
        let hi = UInt32(bitPattern: range.upperBound)._resigned
        let range = Range(uncheckedBounds: (lo, hi))
        let random = UInt32.uncheckedRandom(in: range, using: &randomGenerator)
        return Int32(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Int32>, using randomGenerator: inout R) -> Int32 {
        let lo = UInt32(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt32(bitPattern: closedRange.upperBound)._resigned
        let closedRange = ClosedRange(uncheckedBounds: (lo, hi))
        return Int32(bitPattern: UInt32.random(in: closedRange, using: &randomGenerator)._resigned)
    }

}

extension Int16: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    @inline(__always)
    private static func _resignedRange(from range: Range<Int16>) -> Range<UInt16> {
        let lo = UInt16(bitPattern: range.lowerBound)._resigned
        let hi = UInt16(bitPattern: range.upperBound)._resigned
        return Range(uncheckedBounds: (lo, hi))
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Int16 {
        return Int16(bitPattern: UInt16.random(using: &randomGenerator))
    }

    /// Returns an optional random value of `Self` inside of the range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in range: Range<Int16>, using randomGenerator: inout R) -> Int16? {
        guard let random = UInt16.random(in: _resignedRange(from: range), using: &randomGenerator) else {
            return nil
        }
        return Int16(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Int16>, using randomGenerator: inout R) -> Int16 {
        let lo = UInt16(bitPattern: range.lowerBound)._resigned
        let hi = UInt16(bitPattern: range.upperBound)._resigned
        let range = Range(uncheckedBounds: (lo, hi))
        let random = UInt16.uncheckedRandom(in: range, using: &randomGenerator)
        return Int16(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Int16>, using randomGenerator: inout R) -> Int16 {
        let lo = UInt16(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt16(bitPattern: closedRange.upperBound)._resigned
        let closedRange = ClosedRange(uncheckedBounds: (lo, hi))
        return Int16(bitPattern: UInt16.random(in: closedRange, using: &randomGenerator)._resigned)
    }

}

extension Int8: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    @inline(__always)
    private static func _resignedRange(from range: Range<Int8>) -> Range<UInt8> {
        let lo = UInt8(bitPattern: range.lowerBound)._resigned
        let hi = UInt8(bitPattern: range.upperBound)._resigned
        return Range(uncheckedBounds: (lo, hi))
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Int8 {
        return Int8(bitPattern: UInt8.random(using: &randomGenerator))
    }

    /// Returns an optional random value of `Self` inside of the range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in range: Range<Int8>, using randomGenerator: inout R) -> Int8? {
        guard let random = UInt8.random(in: _resignedRange(from: range), using: &randomGenerator) else {
            return nil
        }
        return Int8(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Int8>, using randomGenerator: inout R) -> Int8 {
        let lo = UInt8(bitPattern: range.lowerBound)._resigned
        let hi = UInt8(bitPattern: range.upperBound)._resigned
        let range = Range(uncheckedBounds: (lo, hi))
        let random = UInt8.uncheckedRandom(in: range, using: &randomGenerator)
        return Int8(bitPattern: random._resigned)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Int8>, using randomGenerator: inout R) -> Int8 {
        let lo = UInt8(bitPattern: closedRange.lowerBound)._resigned
        let hi = UInt8(bitPattern: closedRange.upperBound)._resigned
        let closedRange = ClosedRange(uncheckedBounds: (lo, hi))
        return Int8(bitPattern: UInt8.random(in: closedRange, using: &randomGenerator)._resigned)
    }

}

#if swift(>=3.2)
extension UnsignedInteger where Self: FixedWidthInteger {
    fileprivate var _resigned: Self {
        let bits = Self(extendingOrTruncating: MemoryLayout<Self>.size * 8 - 1)
        return self ^ (1 &<< bits)
    }
}
#endif

extension UInt: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> UInt {
        if MemoryLayout<Int>.size == 8 {
            return UInt(randomGenerator.random64())
        } else {
            return UInt(randomGenerator.random32())
        }
    }

    #if !swift(>=3.2)
    fileprivate var _resigned: UInt {
        let bits: UInt
        #if arch(i386) || arch(arm)
            bits = 31
        #elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x)
            bits = 63
        #else
            bits = UInt(bitPattern: MemoryLayout<UInt>.size * 8 - 1)
        #endif
        return self ^ (1 << bits)
    }
    #endif

}

extension UInt64: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> UInt64 {
        return randomGenerator.random64()
    }

    #if !swift(>=3.2)
    fileprivate var _resigned: UInt64 {
        return self ^ (1 << 63)
    }
    #endif

}

extension UInt32: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> UInt32 {
        return randomGenerator.random32()
    }

    #if !swift(>=3.2)
    fileprivate var _resigned: UInt32 {
        return self ^ (1 << 31)
    }
    #endif

}

extension UInt16: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> UInt16 {
        return randomGenerator.random16()
    }

    #if !swift(>=3.2)
    fileprivate var _resigned: UInt16 {
        return self ^ (1 << 15)
    }
    #endif

}

extension UInt8: UnsafeRandom, RandomWithMax, RandomWithMin, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange, RandomWithMaxWidth, RandomWithExactWidth {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> UInt8 {
        return randomGenerator.random8()
    }

    #if !swift(>=3.2)
    fileprivate var _resigned: UInt8 {
        return self ^ (1 << 7)
    }
    #endif

}
