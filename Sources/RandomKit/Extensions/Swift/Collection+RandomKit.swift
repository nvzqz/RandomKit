//
//  CollectionType+RandomKit.swift
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

extension Collection where Index: RandomWithinRange {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public var random: Iterator.Element? {
        return random(using: .default)
    }

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random(using randomGenerator: RandomGenerator) -> Iterator.Element? {
        guard let index = Index.random(within: Range(uncheckedBounds: (startIndex, endIndex))) else {
            return nil
        }
        return self[index]
    }

}

extension Collection where Index: RandomWithinRange, IndexDistance: RandomToValue {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public var random: Iterator.Element? {
        return random(using: .default)
    }

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random(using randomGenerator: RandomGenerator) -> Iterator.Element? {
        guard let index = Index.random(within: Range(uncheckedBounds: (startIndex, endIndex))) else {
            return nil
        }
        return self[index]
    }

}

extension Collection where IndexDistance: RandomToValue {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public var random: Iterator.Element? {
        return random(using: .default)
    }

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random(using randomGenerator: RandomGenerator) -> Iterator.Element? {
        guard !self.isEmpty else {
            return nil
        }
        let elementIndex = IndexDistance.random(to: distance(from: startIndex, to: endIndex), using: randomGenerator)
        return self[index(startIndex, offsetBy: elementIndex)]
    }

}

extension MutableCollection where Self: Shuffleable, Index: Strideable & RandomWithinRange, Index.Stride: SignedInteger {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled(using randomGenerator: RandomGenerator) -> Self {
        return shuffled(from: startIndex, to: endIndex, using: randomGenerator)
    }

    /// Shuffles the elements in `self`.
    public mutating func shuffle(using randomGenerator: RandomGenerator) {
        shuffle(from: startIndex, to: endIndex, using: randomGenerator)
    }

    /// Shuffles the elements in `self` from `startIndex` to `endIndex` and returns the result.
    public func shuffled(from startIndex: Index,
                         to endIndex: Index,
                         using randomGenerator: RandomGenerator = .default) -> Self {
        var copy = self
        copy.shuffle(from: startIndex, to: endIndex, using: randomGenerator)
        return copy
    }

    /// Shuffles the elements in `self` from `startIndex` to `endIndex`.
    public mutating func shuffle(from startIndex: Index,
                                 to endIndex: Index,
                                 using randomGenerator: RandomGenerator = .default) {
        let range = startIndex ..< endIndex
        for i in range {
            if let j = Index.random(within: range, using: randomGenerator), j != i {
                swap(&self[i], &self[j])
            }
        }
    }

}

extension MutableCollection where Self: UniqueShuffleable, Index: Strideable & RandomWithinRange, Index.Stride: SignedInteger {

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique(using randomGenerator: RandomGenerator) -> Self {
        return shuffledUnique(from: startIndex, to: endIndex, using: randomGenerator)
    }

    /// Shuffles the elements in `self` in a unique order.
    public mutating func shuffleUnique(using randomGenerator: RandomGenerator) {
        shuffleUnique(from: startIndex, to: endIndex, using: randomGenerator)
    }

    /// Shuffles the elements in `self` in a unique order from `startIndex` to `endIndex` and returns the result.
    public func shuffledUnique(from startIndex: Index,
                               to endIndex: Index,
                               using randomGenerator: RandomGenerator = .default) -> Self {
        var copy = self
        copy.shuffleUnique(from: startIndex, to: endIndex, using: randomGenerator)
        return copy

    }

    /// Shuffles the elements in `self` in a unique order from `startIndex` to `endIndex`.
    public mutating func shuffleUnique(from startIndex: Index,
                                       to endIndex: Index,
                                       using randomGenerator: RandomGenerator = .default) {
        for i in startIndex ..< endIndex {
            if let j = Index.random(within: i.advanced(by: 1) ..< endIndex, using: randomGenerator) {
                swap(&self[i], &self[j])
            }
        }
    }

}

extension Array: Shuffleable, UniqueShuffleable {
}

extension ArraySlice: Shuffleable, UniqueShuffleable {
}

extension ContiguousArray: Shuffleable, UniqueShuffleable {
}
