//
//  Set+RandomKit.swift
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

private extension Set {

    init(_ randomCount: Int, _ sequence: AnySequence<Element>, _ elementGenerator: () -> Element) {
        self.init(minimumCapacity: randomCount)
        for var element in sequence {
            while self.contains(element) {
                element = elementGenerator()
            }
            insert(element)
        }
    }

}

extension Set where Element: Random {

    /// Construct a Set of random elements.
    public init(randomCount: Int, using randomGenerator: RandomGenerator = .default) {
        self.init(randomCount,
                  Element.randomSequence(maxCount: randomCount, using: randomGenerator),
                  { Element.random(using: randomGenerator) })
    }

}

extension Set where Element: RandomWithinClosedRange {

    /// Construct a Set of random elements from within the closed range.
    ///
    /// - precondition: Number of elements within `closedRange` >= `randomCount`.
    public init(randomCount: Int,
                within closedRange: ClosedRange<Element>,
                using randomGenerator: RandomGenerator = .default) {
        self.init(randomCount,
                  Element.randomSequence(within: closedRange, maxCount: randomCount, using: randomGenerator),
                  { Element.random(within: closedRange, using: randomGenerator) })
    }

}
