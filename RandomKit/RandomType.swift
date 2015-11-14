//
//  RandomType.swift
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

/// A type that can generate a random value.
public protocol RandomType {

    /// Generates a random value of `Self`.
    static func random() -> Self

}

extension RandomType {

    /// Returns a generator for infinite random values of `Self`.
    public static func randomGenerator() -> AnyGenerator<Self> {
        return anyGenerator { Self.random() }
    }

    /// Returns a generator for random values of `Self` within `maxCount`.
    public static func randomGenerator(maxCount count: Int) -> AnyGenerator<Self> {
        var n = 0
        return anyGenerator { n++ < count ? Self.random() : nil }
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

/// A type that can generate a random value from inside of a closed interval.
public protocol RandomIntervalType : RandomType, Comparable {

    /// Returns a random value of `Self` inside of the closed interval.
    static func random(interval: ClosedInterval<Self>) -> Self

}

extension RandomIntervalType {

    /// Returns a generator for infinite random values of `Self` inside of the closed interval.
    public static func randomGenerator(interval: ClosedInterval<Self>) -> AnyGenerator<Self> {
        return anyGenerator { Self.random(interval) }
    }

    /// Returns a generator for random values of `Self` inside of the closed interval within `maxCount`.
    public static func randomGenerator(interval: ClosedInterval<Self>, maxCount count: Int) -> AnyGenerator<Self> {
        var n = 0
        return anyGenerator { n++ < count ? Self.random(interval) : nil }
    }

    /// Returns a sequence of infinite random values of `Self` inside of the closed interval.
    public static func randomSequence(interval: ClosedInterval<Self>) -> AnySequence<Self> {
        return AnySequence(randomGenerator(interval))
    }

    /// Returns a sequence of random values of `Self` inside of the closed interval within `maxCount`.
    public static func randomSequence(interval: ClosedInterval<Self>, maxCount count: Int) -> AnySequence<Self> {
        return AnySequence(randomGenerator(interval, maxCount: count))
    }
    
}

