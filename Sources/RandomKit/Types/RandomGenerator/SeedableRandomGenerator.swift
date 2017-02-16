//
//  SeedableRandomGenerator.swift
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

/// A random value generator type that can be instantiated with a `Seed`.
public protocol SeedableRandomGenerator: RandomGenerator {

    /// The seed type.
    associatedtype Seed

    /// Creates an instance from `seed`.
    init(seed: Seed)

}

extension SeedableRandomGenerator where Seed: Random {

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        self.init(seed: Seed.random(using: &randomGenerator))
    }

}

extension SeedableRandomGenerator where Self: Random, Seed: Random {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return Self(seededWith: &randomGenerator)
    }

}
