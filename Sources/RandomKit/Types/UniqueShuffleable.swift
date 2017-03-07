//
//  UniqueShuffleable.swift
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

/// A type whose elements can be shuffled in a unique order such that no element is ever in its initial position.
public protocol UniqueShuffleable {

    /// Shuffles the elements in `self` in a unique order and returns the result.
    func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> Self

    /// Shuffles the elements in `self` in a unique order.
    mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R)

}

extension UniqueShuffleable {

    /// Shuffles the elements in `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        self = shuffledUnique(using: &randomGenerator)
    }

}

/// A type whose elements can be shuffled in an index range in a unique order such that no element is ever in its
/// initial position.
public protocol UniqueShuffleableInRange: UniqueShuffleable {

    /// A type that represents a position in an instance of `Self`.
    associatedtype Index: Comparable

    /// Shuffles the elements of `self` in a unique order in `range` and returns the result.
    func shuffledUnique<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Self

    /// Shuffles the elements of `self` in a unique order in `range`.
    mutating func shuffleUnique<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R)

}

extension UniqueShuffleableInRange where Index: Strideable, Index.Stride: SignedInteger {

    /// Shuffles the elements of `self` in a unique order in `range` and returns the result.
    public func shuffledUnique<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) -> Self {
        return shuffledUnique(in: Range(range), using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) {
        shuffleUnique(in: Range(range), using: &randomGenerator)
    }

}
