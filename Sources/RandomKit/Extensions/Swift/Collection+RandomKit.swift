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

extension Collection where IndexDistance == Int {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public var random: Self.Iterator.Element? {
        guard !self.isEmpty else { return nil }
        let distance = self.distance(from: startIndex, to: endIndex)
        let elementIndex = Int(arc4random_uniform(UInt32(distance)))

        return self[self.index(self.startIndex, offsetBy: elementIndex)]
    }

}

extension MutableCollection where Self: Shuffleable, Index == Int {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled() -> Self {
        return shuffled(from: startIndex, to: endIndex)
    }

    /// Shuffles the elements in `self`.
    public mutating func shuffle() {
        shuffle(from: startIndex, to: endIndex)
    }

    /// Shuffles the elements in `self` from `startIndex` to `endIndex` and returns the result.
    public func shuffled(from startIndex: Index, to endIndex: Index) -> Self {
        var copy = self
        copy.shuffle(from: startIndex, to: endIndex)
        return copy
    }

    /// Shuffles the elements in `self` from `startIndex` to `endIndex`.
    public mutating func shuffle(from startIndex: Index, to endIndex: Index) {
        let range = startIndex ..< endIndex
        for i in range {
            if let j = Int.random(within: range), j != i {
                swap(&self[i], &self[j])
            }
        }
    }

}

extension Array: Shuffleable {
}

extension ArraySlice: Shuffleable {
}

extension ContiguousArray: Shuffleable {
}
