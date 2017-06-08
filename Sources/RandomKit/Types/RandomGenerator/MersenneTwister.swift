//
//  MersenneTwister.swift
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

/// A generator that uses the [Mersenne Twister][MT] algorithm.
///
/// [MT]: https://en.wikipedia.org/wiki/Mersenne_Twister
public struct MersenneTwister: RandomBytesGenerator, Seedable, SeedableFromRandomGenerator {

    /// The number of `UInt64` values in a `_State`.
    private static let _stateCount: Int = 312

    /// A default global instance seeded with `DeviceRandom.default`.
    public static var `default` = seeded

    /// A default global instance that reseeds itself with `DeviceRandom.default`.
    public static var defaultReseeding = reseeding

    /// The internal state's type.
    private typealias _State = _Array312<UInt64>

    /// The internal state.
    private var _state: _State = _zero312()

    private var _index: Int

    /// Creates an instance from `seed`.
    public init(seed: UInt64) {
        _index = MersenneTwister._stateCount
        let state = _contents(of: &_state)
        state[0] = seed
        for i in 1 ..< MersenneTwister._stateCount {
            state[i] = 6364136223846793005 &* (state[i &- 1] ^ (state[i &- 1] >> 62)) &+ UInt64(i)
        }
    }

    /// Returns random `Bytes`.
    public mutating func randomBytes() -> UInt64 {
        let state = _contents(of: &_state)

        if _index == MersenneTwister._stateCount {
            let n = MersenneTwister._stateCount
            let m = n / 2
            let a: UInt64 = 0xB5026F5AA96619E9
            let lowerMask: UInt64 = (1 << 31) - 1
            let upperMask: UInt64 = ~lowerMask
            var (i, j, stateM) = (0, m, state[m])
            repeat {
                let x1 = (state[i] & upperMask) | (state[i &+ 1] & lowerMask)
                state[i] = state[i &+ m] ^ (x1 >> 1) ^ ((state[i &+ 1] & 1) &* a)
                let x2 = (state[j] & upperMask) | (state[j &+ 1] & lowerMask)
                state[j] = state[j &- m] ^ (x2 >> 1) ^ ((state[j &+ 1] & 1) &* a)
                (i, j) = (i &+ 1, j &+ 1)
            } while i != m &- 1

            let x3 = (state[m &- 1] & upperMask) | (stateM & lowerMask)
            state[m &- 1] = state[n &- 1] ^ (x3 >> 1) ^ ((stateM & 1) &* a)
            let x4 = (state[n &- 1] & upperMask) | (state[0] & lowerMask)
            state[n &- 1] = state[m &- 1] ^ (x4 >> 1) ^ ((state[0] & 1) &* a)

            _index = 0
        }

        var result = state[_index]
        _index = _index &+ 1

        result ^= (result >> 29) & 0x5555555555555555
        result ^= (result << 17) & 0x71D67FFFEDA60000
        result ^= (result << 37) & 0xFFF7EEE000000000
        result ^= result >> 43

        return result
    }

}
