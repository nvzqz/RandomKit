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

extension Dictionary: ShuffleType {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffle() -> Dictionary {
        let values = Array(self.values).shuffle()
        return zip(keys, values).reduce(Dictionary(minimumCapacity: values.count)) { (dict, pair) in
            var mutableDict = dict

            let (key, value) = pair
            mutableDict[key] = value

            return mutableDict
        }
    }

}

extension Dictionary where Key: RandomType, Value: RandomType {

    fileprivate init(_ randomCount: Int, _ keys: AnySequence<Key>, _ values: AnySequence<Value>, _ keyGenerator: @autoclosure() -> Key) {
        self = zip(keys, values).reduce(Dictionary(minimumCapacity: randomCount)) { (dict, pair) in
            var mutableDict = dict
            var (key, value) = pair

            while dict[key] != nil { // in case of duplicate key
                key = keyGenerator()
            }
            mutableDict[key] = value

            return mutableDict
        }
    }
    
    /// Construct a Dictionary of random elements.
    public init(randomCount: Int) {
        self.init(
            randomCount,
            Key.randomSequence(maxCount: randomCount),
            Value.randomSequence(maxCount: randomCount),
            Key.random())
    }
    
}

extension Dictionary where Key: RandomIntervalType, Value: RandomIntervalType {

    /// Construct a Dictionary of random elements from inside of the closed intervals.
    ///
    /// - Precondition: Number of elements within `keyInterval` >= `randomCount`.
    ///
    public init(randomCount: Int, _ keyInterval: ClosedRange<Key>, _ valueInterval: ClosedRange<Value>) {
        self.init(
            randomCount,
            Key.randomSequence(keyInterval, maxCount: randomCount),
            Value.randomSequence(valueInterval, maxCount: randomCount),
            Key.random(keyInterval))
    }

}
