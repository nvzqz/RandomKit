//
//  Array+RandomKit.swift
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

extension Array: ShuffleType {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffle() -> Array {
        return indices.reduce(self) { (array, i) in
			var mutableArray = array

            let j = Int.random(startIndex ... endIndex - 1)
            if j != i {
				swap(&mutableArray[i], &mutableArray[j])
			}
            return mutableArray
        }
    }

}

extension Array where Element: RandomType {

    /// Construct an Array of random elements.
    public init(randomCount: Int) {
        self = Array(Element.randomSequence(maxCount: randomCount))
    }

}

extension Array where Element: RandomIntervalType {

    /// Construct an Array of random elements from inside of the closed interval.
    public init(randomCount: Int, _ interval: ClosedRange<Element>) {
        self = Array(Element.randomSequence(interval, maxCount: randomCount))
    }

}

extension Array {
    
    /// Returns an array of randomly choosen elements.
    ///
    /// If `elementCount` >= `count` a copy of this array is returned
    ///
    /// - Parameters:
    ///     - elementCount: The number of element to return
    public func randomSlice(_ elementCount: Int) -> Array {
        if elementCount <= 0  {
            return []
        }
        if elementCount >= self.count {
            return Array(self)
        }
        // Algorithm R
        // fill the reservoir array
        var result = Array(self[0..<elementCount])
        // replace elements with gradually decreasing probability
        for i in elementCount..<self.count {
            let j = Int.random((0 ... i-1))
            if j < elementCount {
                result[j] = self[i]
            }
        }
        return result
    }

    /// Returns an array of `elementCount` randomly choosen elements.
    ///
    /// If `elementCount` >= `count` or `weights.count` < `count`
    /// a copy of this array is returned
    ///
    /// - Parameters:
    ///     - elementCount: The number of element to return
    ///     - weights: Apply weights on element.
    public func randomSlice(_ elementCount: Int, weights: [Double]) -> Array {
        if elementCount <= 0  {
            return []
        }
        if elementCount >= self.count || weights.count < self.count {
            return Array(self)
        }

        // Algorithm A-Chao
        var result = Array(self[0..<elementCount])
        var weightSum: Double = weights[0..<elementCount].reduce(0.0) { (total, value) in
            total + value
        }
        for i in elementCount..<self.count {
            let p = weights[i] / weightSum
            let j = Double.random(0.0...1.0)
            if j <= p {
                let index = Int.random((0 ... elementCount-1))
                result[index] = self[i]
            }
            weightSum += weights[i]
        }
        return result
    }

}
