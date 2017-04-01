//
//  Set+RandomKit.swift
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

private extension Set {
    init<S: Sequence>(count: Int, from sequence: S) where S.Iterator.Element == Element {
        self.init(minimumCapacity: count)
        for element in sequence {
            guard self.count < count else {
                break
            }
            insert(element)
        }
    }
}

extension Set: RandomRetrievableInRange {}

extension Set where Element: Random {
    /// Creates a set of random elements using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, using randomGenerator: inout R) {
        self.init(count: randomCount, from: Element.randoms(using: &randomGenerator))
    }
}

extension Set where Element: RandomToValue {
    /// Creates a set of random elements to `value` using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, to value: Element, using randomGenerator: inout R) {
        self.init(count: randomCount, from: Element.randoms(to: value, using: &randomGenerator))
    }
}

extension Set where Element: RandomThroughValue {
    /// Creates a set of random elements through `value` using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, through value: Element, using randomGenerator: inout R) {
        self.init(count: randomCount, from: Element.randoms(through: value, using: &randomGenerator))
    }
}

extension Set where Element: RandomInRange {
    /// Creates a set of random elements in `range` using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, in range: Range<Element>, using randomGenerator: inout R) {
        if range.isEmpty {
            self.init()
        } else {
            self.init(count: randomCount, from: Element.randoms(in: range, using: &randomGenerator))
        }
    }
}

extension Set where Element: RandomInClosedRange {
    /// Creates a set of random elements in `closedRange` using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, in closedRange: ClosedRange<Element>, using randomGenerator: inout R) {
        self.init(count: randomCount, from: Element.randoms(in: closedRange, using: &randomGenerator))
    }
}

extension Set where Element: RandomWithMaxWidth {
    /// Creates a set of random elements with a max width using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, withMaxWidth width: Int, using randomGenerator: inout R) {
        self.init(count: randomCount, from: Element.randoms(withMaxWidth: width, using: &randomGenerator))
    }
}

extension Set where Element: RandomWithExactWidth {
    /// Creates a set of random elements with an exact width using `randomGenerator`.
    public init<R: RandomGenerator>(randomCount: Int, withExactWidth width: Int, using randomGenerator: inout R) {
        self.init(count: randomCount, from: Element.randoms(withExactWidth: width, using: &randomGenerator))
    }
}
