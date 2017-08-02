//
//  Strideable+RandomKit.swift
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

extension Strideable where Self: RandomInRange, Stride: RandomToValue {

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<Self>, using randomGenerator: inout R) -> Self {
        let distance = range.lowerBound.distance(to: range.upperBound)
        return range.lowerBound.advanced(by: .random(to: distance, using: &randomGenerator))
    }

}

extension Strideable where Self: RandomInClosedRange, Stride: RandomThroughValue {

    /// Returns a random value of `Self` inside of the closed range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> Self {
        let distance = closedRange.lowerBound.distance(to: closedRange.upperBound)
        return closedRange.lowerBound.advanced(by: .random(through: distance, using: &randomGenerator))
    }

}

extension String.UTF16Index: RandomInRange, RandomInClosedRange {

    #if swift(>=3.2)

    /// Returns a random value of `Self` inside of the unchecked range using `randomGenerator`.
    public static func uncheckedRandom<R: RandomGenerator>(in range: Range<String.Index>, using randomGenerator: inout R) -> String.Index {
        let lo = range.lowerBound.encodedOffset
        let hi = range.upperBound.encodedOffset
        let rg = Range(uncheckedBounds: (lo, hi))
        return String.Index(encodedOffset: rg.uncheckedRandom(using: &randomGenerator))
    }

    /// Returns a random value of `Self` inside of the closed range using `randomGenerator`.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<String.Index>, using randomGenerator: inout R) -> String.Index {
        let lo = closedRange.lowerBound.encodedOffset
        let hi = closedRange.upperBound.encodedOffset
        let cr = ClosedRange(uncheckedBounds: (lo, hi))
        return String.Index(encodedOffset: cr.uncheckedRandom(using: &randomGenerator))
    }

    #endif

}

extension UnsafePointer: RandomInRange, RandomInClosedRange {
}

extension UnsafeMutablePointer: RandomInRange, RandomInClosedRange {
}

extension UnsafeRawPointer: RandomInRange, RandomInClosedRange {
}

extension UnsafeMutableRawPointer: RandomInRange, RandomInClosedRange {
}
