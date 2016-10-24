//
//  Dictionary+RandomKit.swift
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

extension Dictionary: Shuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled() -> Dictionary {
        var copy = self
        copy.shuffle()
        return copy
    }

    /// Shuffles the elements in `self`.
    public mutating func shuffle() {
        for (key, value) in zip(keys, Array(values).shuffled()) {
            self[key] = value
        }
    }

}

extension Dictionary where Key: Random, Value: Random {

    fileprivate init(_ randomCount: Int, _ keys: AnySequence<Key>, _ values: AnySequence<Value>, _ keyGenerator: @autoclosure () -> Key) {
        self.init(minimumCapacity: randomCount)
        for (key, value) in zip(keys, values) {
            var key = key
            while case .some = self[key] {
                key = keyGenerator()
            }
            self[key] = value
        }
    }

    /// Construct a Dictionary of random elements.
    public init(randomCount: Int) {
        self.init(randomCount,
                  Key.randomSequence(maxCount: randomCount),
                  Value.randomSequence(maxCount: randomCount),
                  Key.random())
    }

}

extension Dictionary where Key: RandomWithinClosedRange, Value: RandomWithinClosedRange {

    /// Construct a Dictionary of random elements from within the closed ranges.
    ///
    /// - Precondition: Number of elements within `keyRange` >= `randomCount`.
    ///
    public init(randomCount: Int, _ keyRange: ClosedRange<Key>, _ valueRange: ClosedRange<Value>) {
        self.init(randomCount,
                  Key.randomSequence(within: keyRange, maxCount: randomCount),
                  Value.randomSequence(within: valueRange, maxCount: randomCount),
                  Key.random(within: keyRange))
    }

}
