//
//  Xoroshiro.swift
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

import Foundation

/// A generator that uses the [Xoroshiro][site] algorithm.
///
/// [site]: http://xoroshiro.di.unimi.it/
public struct Xoroshiro: RandomBytesGenerator, SeedableRandomGenerator, Random {

    /// A default global instance.
    public static var `default` = Xoroshiro(seededWith: &DeviceRandom.default)

    /// The internal state.
    private var _state: (UInt64, UInt64)

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Xoroshiro {
        return Xoroshiro(seededWith: &randomGenerator)
    }

    /// Creates an instance from `seed`.
    public init(seed: (UInt64, UInt64)) {
        _state = seed
    }

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        var seed: Seed = (0, 0)
        randomGenerator.randomize(value: &seed)
        self.init(seed: seed)
    }

    /// Returns random `Bytes`.
    public mutating func randomBytes() -> UInt64 {
        let (l, k0, k1, k2): (UInt64, UInt64, UInt64, UInt64) = (64, 55, 14, 36)
        let result = _state.0 &+ _state.1
        let x = _state.0 ^ _state.1
        _state.0 = ((_state.0 << k0) | (_state.0 >> (l - k0))) ^ x ^ (x << k1)
        _state.1 = (x << k2) | (x >> (l - k2))
        return result
    }

}
