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

extension NSArray {
    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Any? {
        let count = self.count
        guard count > 0 else {
            return nil
        }
        return self[Int.random(to: count, using: &randomGenerator)]
    }
}

extension NSMutableArray: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements of `self`.
    public func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        let range = CountableRange(uncheckedBounds: (0, count))
        for i in range {
            let j = Int.uncheckedRandom(within: range, using: &randomGenerator)
            if j != i {
                swap(&self[i], &self[j])
            }
        }
    }

    /// Shuffles the elements of `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        func copy<T>(as _: T.Type) -> T {
            return mutableCopy() as! T
        }
        let result = copy(as: type(of: self))
        result.shuffle(using: &randomGenerator)
        return result
    }


    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        let count = self.count
        guard count > 0 else {
            return
        }
        for i in CountableRange(uncheckedBounds: (0, count &- 1)) {
            let randomRange = Range(uncheckedBounds: (i &+ 1, count))
            let j = Int.uncheckedRandom(within: randomRange, using: &randomGenerator)
            swap(&self[i], &self[j])
        }
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        func copy<T>(as _: T.Type) -> T {
            return mutableCopy() as! T
        }
        let result = copy(as: type(of: self))
        result.shuffleUnique(using: &randomGenerator)
        return result
    }

}
