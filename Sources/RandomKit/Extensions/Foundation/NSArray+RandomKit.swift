//
//  NSArray+RandomKit.swift
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

import Foundation

extension NSArray: RandomRetrievableInRange {

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Any {
        let index = Int.uncheckedRandom(in: range, using: &randomGenerator)
        return self[index]
    }

    /// Returns a random element in `self` without checking whether `self` is empty.
    public func uncheckedRandom<R: RandomGenerator>(using randomGenerator: inout R) -> Any {
        return uncheckedRandom(in: Range(uncheckedBounds: (0, count)), using: &randomGenerator)
    }

    /// Returns an optional random element in `range`. The result is `nil` if `self` or `range` is empty.
    public func random<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Any? {
        if range.lowerBound < 0 || range.upperBound > count {
            return nil
        }
        return uncheckedRandom(in: range, using: &randomGenerator)
    }

    /// Returns an optional random element in `self`. The result is `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Any? {
        return count > 0 ? uncheckedRandom(using: &randomGenerator) : nil
    }

}

extension NSMutableArray: ShuffleableInRange, UniqueShuffleableInRange {

    private func _mutableCopy() -> Self {
        func makeCopy<T>() -> T {
            return mutableCopy() as! T
        }
        return makeCopy()
    }

    /// Shuffles the elements of `self` in `range`.
    public func shuffle<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        for i in CountableRange(range) {
            let j = Index.uncheckedRandom(in: range, using: &randomGenerator)
            if j != i {
                exchangeObject(at: i, withObjectAt: j)
            }
        }
    }

    /// Shuffles the elements of `self` in `range` and returns the result.
    public func shuffled<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Self {
        let result = _mutableCopy()
        result.shuffle(in: range, using: &randomGenerator)
        return result
    }

    /// Shuffles the elements of `self`.
    public func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        shuffle(in: Range(uncheckedBounds: (0, count)), using: &randomGenerator)
    }

    /// Shuffles the elements of `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        let result = _mutableCopy()
        result.shuffle(using: &randomGenerator)
        return result
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public func shuffleUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        if range.isEmpty {
            return
        }
        for i in CountableRange(uncheckedBounds: (range.lowerBound, range.upperBound.advanced(by: -1))) {
            let randomRange = Range(uncheckedBounds: (i.advanced(by: 1), range.upperBound))
            let j = Index.uncheckedRandom(in: randomRange, using: &randomGenerator)
            exchangeObject(at: i, withObjectAt: j)
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range` and returns the result.
    public func shuffledUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Self {
        let result = _mutableCopy()
        result.shuffleUnique(in: range, using: &randomGenerator)
        return result
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        shuffleUnique(in: Range(uncheckedBounds: (0, count)), using: &randomGenerator)
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        let result = _mutableCopy()
        result.shuffleUnique(using: &randomGenerator)
        return result
    }

}
