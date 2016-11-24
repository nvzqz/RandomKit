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

extension Dictionary: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled(using randomGenerator: RandomGenerator) -> Dictionary {
        var copy = self
        copy.shuffle(using: randomGenerator)
        return copy
    }

    /// Shuffles the elements in `self`.
    public mutating func shuffle(using randomGenerator: RandomGenerator) {
        for (key, value) in zip(keys, Array(values).shuffled(using: randomGenerator)) {
            self[key] = value
        }
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique(using randomGenerator: RandomGenerator) -> Dictionary {
        var copy = self
        copy.shuffleUnique(using: randomGenerator)
        return copy
    }

    /// Shuffles the elements in `self` in a unique order.
    public mutating func shuffleUnique(using randomGenerator: RandomGenerator) {
        for (key, value) in zip(keys, Array(values).shuffledUnique(using: randomGenerator)) {
            self[key] = value
        }
    }

}

private extension Dictionary {

    init(_ randomCount: Int, _ keys: AnySequence<Key>, _ values: AnySequence<Value>, _ keyGenerator: () -> Key) {
        self.init(minimumCapacity: randomCount)
        for (key, value) in zip(keys, values) {
            var key = key
            while case .some = self[key] {
                key = keyGenerator()
            }
            self[key] = value
        }
    }

}

extension Dictionary where Key: Random, Value: Random {

    /// Construct a Dictionary of random elements.
    public init(randomCount: Int, using randomGenerator: RandomGenerator = .default) {
        self.init(randomCount,
                  Key.randomSequence(maxCount: randomCount, using: randomGenerator),
                  Value.randomSequence(maxCount: randomCount, using: randomGenerator),
                  { Key.random(using: randomGenerator) })
    }

}

extension Dictionary where Key: RandomWithinClosedRange, Value: RandomWithinClosedRange {

    /// Construct a Dictionary of random elements from within the closed ranges.
    ///
    /// - precondition: Number of elements within `keyRange` >= `randomCount`.
    public init(randomCount: Int,
                _ keyRange: ClosedRange<Key>,
                _ valueRange: ClosedRange<Value>,
                using randomGenerator: RandomGenerator = .default) {
        self.init(randomCount,
                  Key.randomSequence(within: keyRange, maxCount: randomCount, using: randomGenerator),
                  Value.randomSequence(within: valueRange, maxCount: randomCount, using: randomGenerator),
                  { Key.random(within: keyRange, using: randomGenerator) })
    }

}
