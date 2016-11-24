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
    ///
    /// Although safety is not guaranteed, `init(unsafeRandomCount:)` is *significantly* faster than this.
    public init(randomCount: Int, using randomGenerator: RandomGenerator = .default) {
        self = (0 ..< randomCount).map { _ in Element.random(using: randomGenerator) }
    }

}

extension Array where Element: UnsafeRandom {

    /// Construct an Array of random elements by randomizing the buffer directly.
    ///
    /// This is *significantly* faster than using `init(randomCount:using:)`.
    public init(unsafeRandomCount: Int, using randomGenerator: RandomGenerator = .default) {
        self.init(repeating: .randomizableValue, count: unsafeRandomCount)
        let buffer = UnsafeMutablePointer(mutating: self)
        randomGenerator.randomize(buffer: buffer, size: MemoryLayout<Element>.size * unsafeRandomCount)
    }

}

extension Array where Element: RandomWithinRange {

    /// Construct an Array of random elements from within the range.
    public init(randomCount: Int,
                within range: Range<Element>,
                using randomGenerator: RandomGenerator = .default) {
        if range.isEmpty {
            self = []
        } else {
            self = (0 ..< randomCount).map { _ in
                Element.random(within: range, using: randomGenerator).unsafelyUnwrapped
            }
        }
    }

}

extension Array where Element: RandomWithinClosedRange {

    /// Construct an Array of random elements from within the closed range.
    public init(randomCount: Int,
                within closedRange: ClosedRange<Element>,
                using randomGenerator: RandomGenerator = .default) {
        self = (0 ..< randomCount).map { _ in Element.random(within: closedRange, using: randomGenerator) }
    }

}

extension Array {

    /// Returns an array of randomly choosen elements.
    ///
    /// If `count` >= `self.count` a copy of this array is returned.
    ///
    /// - parameter count: The number of elements to return.
    /// - parameter randomGenerator: The random generator to use.
    public func randomSlice(count: Int, using randomGenerator: RandomGenerator = .default) -> Array {
        if count <= 0  {
            return []
        }
        if count >= self.count {
            return Array(self)
        }
        // Algorithm R
        // fill the reservoir array
        var result = Array(self[0..<count])
        // replace elements with gradually decreasing probability
        for i in count..<self.count {
            let j = Int.random(within: 0 ... i-1, using: randomGenerator)
            if j < count {
                result[j] = self[i]
            }
        }
        return result
    }

    /// Returns an array of `count` randomly choosen elements.
    ///
    /// If `count` >= `self.count` or `weights.count` < `self.count` a copy of this array is returned.
    ///
    /// - parameter count: The number of elements to return.
    /// - parameter weights: Apply weights on element.
    /// - parameter randomGenerator: The random generator to use.
    public func randomSlice(count: Int, weights: [Double], using randomGenerator: RandomGenerator = .default) -> Array {
        if count <= 0  {
            return []
        }
        if count >= self.count || weights.count < self.count {
            return Array(self)
        }

        // Algorithm A-Chao
        var result = Array(self[0..<count])
        var weightSum: Double = weights[0..<count].reduce(0.0) { (total, value) in
            total + value
        }
        for i in count..<self.count {
            let p = weights[i] / weightSum
            let j = Double.random(within: 0.0...1.0, using: randomGenerator)
            if j <= p {
                let index = Int.random(within: 0 ... count-1, using: randomGenerator)
                result[index] = self[i]
            }
            weightSum += weights[i]
        }
        return result
    }

}
