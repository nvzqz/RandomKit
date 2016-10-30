//
//  RandomThroughValue.swift
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

/// A type that can generate a random value from a base through a value.
public protocol RandomThroughValue {

    /// The random base from which to generate.
    static var randomBase: Self { get }

    /// Generates a random value of `Self` from `Self.randomBase` through `value` using `randomGenerator`.
    static func random(through value: Self, using randomGenerator: RandomGenerator) -> Self

}

extension RandomThroughValue {

    /// Generates a random value of `Self` from `Self.randomBase` through `value` using the default generator.
    public static func random(through value: Self) -> Self {
        return random(through: value, using: .default)
    }

}

extension RandomThroughValue where Self: RandomWithMax {

    /// Generates a random value of `Self` from `Self.randomBase` through `Self.max` using `randomGenerator`.
    public static func randomThroughMax(using randomGenerator: RandomGenerator = .default) -> Self {
        return random(through: max, using: randomGenerator)
    }

}

extension RandomThroughValue where Self: RandomWithMin {

    /// Generates a random value of `Self` from `Self.randomBase` through `Self.min` using `randomGenerator`.
    public static func randomThroughMin(using randomGenerator: RandomGenerator = .default) -> Self {
        return random(through: min, using: randomGenerator)
    }

}
