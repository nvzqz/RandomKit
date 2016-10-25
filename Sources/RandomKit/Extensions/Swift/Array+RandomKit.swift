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

extension Array where Element: Random {

    /// Construct an Array of random elements.
    public init(randomCount: Int, using randomGenerator: RandomGenerator = .default) {
        self.init(Element.randomSequence(maxCount: randomCount, using: randomGenerator))
    }

}

extension Array where Element: RandomWithinRange {

    /// Construct an Array of random elements from within the range.
    public init(randomCount: Int,
                within range: Range<Element>,
                using randomGenerator: RandomGenerator = .default) {
        self.init(Element.randomSequence(within: range, maxCount: randomCount, using: randomGenerator))
    }

}

extension Array where Element: RandomWithinClosedRange {

    /// Construct an Array of random elements from within the closed range.
    public init(randomCount: Int,
                within closedRange: ClosedRange<Element>,
                using randomGenerator: RandomGenerator = .default) {
        self.init(Element.randomSequence(within: closedRange, maxCount: randomCount, using: randomGenerator))
    }

}

extension Array {

    /// Returns an array of randomly choosen elements.
    ///
    /// If `elementCount` >= `count` a copy of this array is returned
    ///
    /// - parameter elementCount: The number of element to return
    /// - parameter randomGenerator: The random generator to use.
    public func randomSlice(_ elementCount: Int, using randomGenerator: RandomGenerator = .default) -> Array {
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
            let j = Int.random(within: 0 ... i-1, using: randomGenerator)
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
    /// - parameter elementCount: The number of element to return
    /// - parameter weights: Apply weights on element.
    /// - parameter randomGenerator: The random generator to use.
    public func randomSlice(_ elementCount: Int, weights: [Double], using randomGenerator: RandomGenerator = .default) -> Array {
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
            let j = Double.random(within: 0.0...1.0, using: randomGenerator)
            if j <= p {
                let index = Int.random(within: 0 ... elementCount-1, using: randomGenerator)
                result[index] = self[i]
            }
            weightSum += weights[i]
        }
        return result
    }

}
