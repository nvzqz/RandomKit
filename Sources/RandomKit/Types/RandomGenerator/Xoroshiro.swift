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
//  Copyright (c) 2008-2017 Matt Gallagher (http://cocoawithlove.com). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
//  REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
//  AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
//  INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
//  FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
//  NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH
//  THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

/// A generator that uses the [Xoroshiro][1] algorithm.
///
/// Its source is located [here][2].
///
/// [1]: http://xoroshiro.di.unimi.it/
/// [2]: http://xoroshiro.di.unimi.it/xoroshiro128plus.c
public struct Xoroshiro: RandomBytesGenerator, Seedable, SeedableFromRandomGenerator {

    /// A default global instance seeded with `DeviceRandom.default`.
    public static var `default` = seeded

    /// A default global instance that reseeds itself with `DeviceRandom.default`.
    public static var defaultReseeding = reseeding

    /// The internal state.
    private var _state: (UInt64, UInt64)

    /// Creates an instance from `seed`.
    public init(seed: (UInt64, UInt64)) {
        _state = seed
    }

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        var seed: Seed = (0, 0)
        repeat {
            randomGenerator.randomize(value: &seed)
        } while seed == (0, 0)
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

    /// Advances the generator 2^64 calls forward.
    public mutating func jump() {
        var s0: UInt64 = 0
        var s1: UInt64 = 0
        @inline(__always)
        func doThings(with value: UInt64) {
            for i: UInt64 in 0 ..< 64 {
                if value & 1 << i != 0 {
                    s0 ^= _state.0
                    s1 ^= _state.1
                }
                _ = randomBytes()
            }
        }
        doThings(with: 0xBEAC0467EBA5FACB)
        doThings(with: 0xD86B048B86AA9922)
        _state = (s0, s1)
    }

    /// Advances the generator `count` * (2^64) calls forward.
    ///
    /// - parameter count: The number of jumps to make.
    public mutating func jump(count: UInt) {
        for _ in 0 ..< count {
            jump()
        }
    }

}
