//
//  RandomRetrievable.swift
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

/// A type where a random element can be retrieved from an instance of `Self`.
public protocol RandomRetrievable: Sequence {

    /// Returns a random element in `self` without checking whether `self` is empty.
    func uncheckedRandom<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element

    /// Returns an optional random element in `self`. The result is `nil` if `self` is empty.
    func random<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element?

}

/// A type where a random element can be retrieved from an instance of `Self` in an index range.
public protocol RandomRetrievableInRange: RandomRetrievable {

    /// A type that represents a position in an instance of `Self`.
    associatedtype Index: Comparable

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    func uncheckedRandom<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Iterator.Element

    /// Returns an optional random element in `range`. The result is `nil` if `self` or `range` is empty.
    func random<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Iterator.Element?

}

extension RandomRetrievableInRange where Index: Strideable, Index.Stride: SignedInteger {

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) -> Iterator.Element {
        return uncheckedRandom(in: Range(range), using: &randomGenerator)
    }

    /// Returns an optional random element in `range`. The result is `nil` if `self` or `range` is empty.
    public func random<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) -> Iterator.Element? {
        return random(in: Range(range), using: &randomGenerator)
    }

}
