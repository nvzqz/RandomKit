//
//  Dictionary+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolai Vazquez
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
        return zip(keys, values).reduce(Dictionary(minimumCapacity: values.count)) { (var dict, pair) in
            let (key, value) = pair
            dict[key] = value
            return dict
        }
    }

}

extension Dictionary where Key: RandomType, Value: RandomType {
    
    /// Construct a Dictionary of random elements.
    public init(randomCount: Int) {
        let keys = Key.randomSequence(maxCount: randomCount)
        let values = Value.randomSequence(maxCount: randomCount)
        self = zip(keys, values).reduce(Dictionary(minimumCapacity: randomCount)) { (var dict, pair) in
            let (key, value) = pair
            var finalKey = key
            while dict[finalKey] != nil { // in case of duplicate key
                finalKey = Key.random()
            }
            dict[finalKey] = value
            return dict
        }
    }
    
}
