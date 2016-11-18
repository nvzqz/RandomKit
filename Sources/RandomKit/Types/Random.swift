//
//  Random.swift
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

/// A type that can generate a random value.
public protocol Random {

    /// Generates a random value of `Self` using `randomGenerator`.
    static func random(using randomGenerator: RandomGenerator) -> Self

}

extension Random {

    /// Generates a random value of `Self` using the default generator.
    public static func random() -> Self {
        return random(using: .default)
    }

    /// Returns an iterator for infinite random values of `Self`.
    public static func randomIterator(using randomGenerator: RandomGenerator = .default) -> AnyIterator<Self> {
        return AnyIterator { random(using: randomGenerator) }
    }

    /// Returns an iterator for random values of `Self` within `maxCount`.
    public static func randomIterator<I: Strideable & ExpressibleByIntegerLiteral>(maxCount: I,
                                      using randomGenerator: RandomGenerator = .default) -> AnyIterator<Self> {
        var n: I = 0
        return AnyIterator {
            defer { n  = n.advanced(by: 1) }
            return n < maxCount ? random(using: randomGenerator) : nil
        }
    }

    /// Returns a sequence of infinite random values of `Self`.
    public static func randomSequence(using randomGenerator: RandomGenerator = .default) -> AnySequence<Self> {
        return AnySequence(randomIterator(using: randomGenerator))
    }

    /// Returns a sequence of random values of `Self` within `maxCount`.
    public static func randomSequence<I: Strideable & ExpressibleByIntegerLiteral>(maxCount: I,
                                      using randomGenerator: RandomGenerator = .default) -> AnySequence<Self> {
        return AnySequence(randomIterator(maxCount: maxCount, using: randomGenerator))
    }

}
