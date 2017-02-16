//
//  RandomWithExactWidth.swift
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

/// A type that can generate a random value with an exact width.
public protocol RandomWithExactWidth {

    /// Generates a random value of `Self` with an exact width using `randomGenerator`.
    static func random<R: RandomGenerator>(withExactWidth width: Int, using randomGenerator: inout R) -> Self

}

extension RandomWithExactWidth {

    /// Returns a sequence of random values with an exact width using `randomGenerator`.
    public static func randoms<R: RandomGenerator>(withExactWidth width: Int, using randomGenerator: inout R) -> RandomsWithExactWidth<Self, R> {
        return RandomsWithExactWidth(width: width, randomGenerator: &randomGenerator)
    }

    /// Returns a sequence of random values limited by `limit` with an exact width using `randomGenerator`.
    public static func randoms<R: RandomGenerator>(limitedBy limit: Int, withExactWidth width: Int, using randomGenerator: inout R) -> LimitedRandomsWithExactWidth<Self, R> {
        return LimitedRandomsWithExactWidth(limit: limit, width: width, randomGenerator: &randomGenerator)
    }

}

/// A sequence of random values of a `RandomWithExactWidth` type, generated by a `RandomGenerator`.
///
/// - warning: An instance *should not* outlive its `RandomGenerator`.
///
/// - seealso: `LimitedRandomsWithExactWidth`
public struct RandomsWithExactWidth<Element: RandomWithExactWidth, RG: RandomGenerator>: IteratorProtocol, Sequence {

    /// A pointer to the `RandomGenerator`
    private let _randomGenerator: UnsafeMutablePointer<RG>

    /// The exact width to generate within.
    public var width: Int

    /// Creates an instance with `width` and `randomGenerator`.
    public init(width: Int, randomGenerator: inout RG) {
        _randomGenerator = UnsafeMutablePointer(&randomGenerator)
        self.width = width
    }

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists. Once `nil` has been returned, all subsequent calls return `nil`.
    public mutating func next() -> Element? {
        return Element.random(withExactWidth: width, using: &_randomGenerator.pointee)
    }

}

/// A limited sequence of random values of a `RandomWithExactWidth` type, generated by a `RandomGenerator`.
///
/// - warning: An instance *should not* outlive its `RandomGenerator`.
///
/// - seealso: `RandomsWithExactWidth`
public struct LimitedRandomsWithExactWidth<Element: RandomWithExactWidth, RG: RandomGenerator>: IteratorProtocol, Sequence {

    /// A pointer to the `RandomGenerator`
    private let _randomGenerator: UnsafeMutablePointer<RG>

    /// The iteration for the random value generation.
    private var _iteration: Int = 0

    /// The limit value.
    public var limit: Int

    /// The exact width to generate within.
    public var width: Int

    /// A value less than or equal to the number of elements in
    /// the sequence, calculated nondestructively.
    ///
    /// - Complexity: O(1)
    public var underestimatedCount: Int {
        return limit
    }

    /// Creates an instance with `limit`, `width`, and `randomGenerator`.
    public init(limit: Int, width: Int, randomGenerator: inout RG) {
        _randomGenerator = UnsafeMutablePointer(&randomGenerator)
        self.limit = limit
        self.width = width
    }

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists. Once `nil` has been returned, all subsequent calls return `nil`.
    public mutating func next() -> Element? {
        guard _iteration < limit else { return nil }
        _iteration = _iteration &+ 1
        return Element.random(withExactWidth: width, using: &_randomGenerator.pointee)
    }

}
