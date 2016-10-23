//
//  RandomProtocol.swift
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
public protocol RandomProtocol {

    /// Generates a random value of `Self`.
    static func random() -> Self

}

extension RandomProtocol {

    /// Returns a generator for infinite random values of `Self`.
    public static func randomGenerator() -> AnyIterator<Self> {
        return AnyIterator { random() }
    }

    /// Returns a generator for random values of `Self` within `maxCount`.
    public static func randomGenerator(maxCount count: Int) -> AnyIterator<Self> {
        var n = 0
        return AnyIterator {
            defer { n += 1 }
            return n < count ? random() : nil
        }
    }

    /// Returns a sequence of infinite random values of `Self`.
    public static func randomSequence() -> AnySequence<Self> {
        return AnySequence(randomGenerator())
    }

    /// Returns a sequence of random values of `Self` within `maxCount`.
    public static func randomSequence(maxCount count: Int) -> AnySequence<Self> {
        return AnySequence(randomGenerator(maxCount: count))
    }

}
