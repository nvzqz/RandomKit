//
//  FloatingPoint+RandomKit.swift
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

extension FloatingPoint where Self: RandomInRange {

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Self>, using randomGenerator: inout R) -> Self {
        let random = UInt.random(using: &randomGenerator)
        if random == 0 {
            return range.lowerBound
        } else {
            let multiplier = range.upperBound - range.lowerBound
            return range.lowerBound + multiplier * (Self(random - 1) / Self(UInt.max))
        }
    }

}

extension FloatingPoint where Self: RandomInClosedRange {

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> Self {
        let multiplier = closedRange.upperBound - closedRange.lowerBound
        return closedRange.lowerBound + multiplier * (Self(UInt.random(using: &randomGenerator)) / Self(UInt.max))
    }

}

extension FloatingPoint where Self: Random & RandomInClosedRange {

    /// Generates a random value of `Self`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return random(in: 0...1, using: &randomGenerator)
    }

}

extension FloatingPoint where Self: RandomToValue & RandomThroughValue {

    /// The random base from which to generate.
    public static var randomBase: Self {
        return 0
    }

}

extension FloatingPoint where Self: RandomInClosedRange & RandomThroughValue {

    /// Generates a random value of `Self` from `Self.randomBase` through `value` using `randomGenerator`.
    public static func random<R: RandomGenerator>(through value: Self, using randomGenerator: inout R) -> Self {
        let range: ClosedRange<Self>
        if value < randomBase {
            range = value...randomBase
        } else {
            range = randomBase...value
        }
        return random(in: range, using: &randomGenerator)
    }

}

extension FloatingPoint where Self: RandomInRange & RandomToValue {

    /// Generates a random value of `Self` from `Self.randomBase` to `value` using `randomGenerator`.
    public static func random<R: RandomGenerator>(to value: Self, using randomGenerator: inout R) -> Self {
        let negate = value < randomBase
        let newValue = negate ? -value : value
        let randomRange = Range(uncheckedBounds: (randomBase, newValue))
        guard let random = self.random(in: randomRange, using: &randomGenerator) else {
            return randomBase
        }
        return negate ? -random : random
    }

}

extension Double: Random, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Double {
        return randomGenerator.randomClosed64()
    }

}

extension Float: Random, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Float {
        return randomGenerator.randomClosed32()
    }

}

#if arch(i386) || arch(x86_64)
extension Float80: Random, RandomToValue, RandomThroughValue, RandomInRange, RandomInClosedRange {
}
#endif
