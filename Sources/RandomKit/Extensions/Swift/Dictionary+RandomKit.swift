//
//  Dictionary+RandomKit.swift
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

extension Dictionary: RandomRetrievableInRange, Shuffleable, UniqueShuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> Dictionary {
        var copy = self
        copy.shuffle(using: &randomGenerator)
        return copy
    }

    /// Shuffles the elements in `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        var values = Array(self.values)
        values.shuffle(using: &randomGenerator)
        for (key, value) in zip(keys, values) {
            self[key] = value
        }
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> Dictionary {
        var copy = self
        copy.shuffleUnique(using: &randomGenerator)
        return copy
    }

    /// Shuffles the elements in `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        var values = Array(self.values)
        values.shuffle(using: &randomGenerator)
        for (key, value) in zip(keys, values) {
            self[key] = value
        }
    }

}

private extension Dictionary {
    init<K: Sequence, V: Sequence>(count: Int, keys: K, values: V) where K.Iterator.Element == Key, V.Iterator.Element == Value {
        self.init(minimumCapacity: count)
        var keysIterator = keys.makeIterator()
        var valuesIterator = values.makeIterator()
        while self.count < count, var key = keysIterator.next(), let value = valuesIterator.next() {
            while case .some = self[key] {
                guard let next = keysIterator.next() else {
                    return
                }
                key = next
            }
            self[key] = value
        }
    }
}

extension Dictionary where Key: Random, Value: Random {
    /// Creates a set of random key-value pairs using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, using randomGenerator: inout R) {
        let keys = Key.randoms(using: &randomGenerator)
        let values = Value.randoms(using: &randomGenerator)
        self.init(count: randomCount, keys: keys, values: values)
    }
}

extension Dictionary where Key: RandomToValue, Value: RandomToValue {
    /// Creates a set of random key-value pairs to a key and value using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, toKey key: Key, toValue value: Value, using randomGenerator: inout R) {
        let keys = Key.randoms(to: key, using: &randomGenerator)
        let values = Value.randoms(to: value, using: &randomGenerator)
        self.init(count: randomCount, keys: keys, values: values)
    }
}

extension Dictionary where Key: RandomThroughValue, Value: RandomThroughValue {
    /// Creates a set of random key-value pairs through a key and value using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, throughKey key: Key, throughValue value: Value, using randomGenerator: inout R) {
        let keys = Key.randoms(through: key, using: &randomGenerator)
        let values = Value.randoms(through: value, using: &randomGenerator)
        self.init(count: randomCount, keys: keys, values: values)
    }
}

extension Dictionary where Key: RandomInRange, Value: RandomInRange {
    /// Creates a set of random key-value pairs in key and value ranges using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, inKeys keys: Range<Key>, inValues values: Range<Value>, using randomGenerator: inout R) {
        let keys = Key.randoms(in: keys, using: &randomGenerator)
        let values = Value.randoms(in: values, using: &randomGenerator)
        self.init(count: randomCount, keys: keys, values: values)
    }
}

extension Dictionary where Key: RandomInClosedRange, Value: RandomInClosedRange {
    /// Creates a set of random key-value pairs in key and value closed ranges using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, inKeys keys: ClosedRange<Key>, inValues values: ClosedRange<Value>, using randomGenerator: inout R) {
        let keys = Key.randoms(in: keys, using: &randomGenerator)
        let values = Value.randoms(in: values, using: &randomGenerator)
        self.init(count: randomCount, keys: keys, values: values)
    }
}
