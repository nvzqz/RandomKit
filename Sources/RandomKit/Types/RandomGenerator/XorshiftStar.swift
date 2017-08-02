//
//  XorshiftStar.swift
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

/// A generator that uses the [Xorshift1024*][1] algorithm.
///
/// [1]: http://xoroshiro.di.unimi.it/xorshift1024star.c
public struct XorshiftStar: RandomBytesGenerator, Seedable, SeedableFromRandomGenerator {

    /// The seed type.
    public typealias Seed = (
        UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64
    )

    private typealias _State = _Array16<UInt64>

    private static var _jump: _State = (
        0x84242F96ECA9C41D, 0xA3C65B8776F96855, 0x5B34A39F070B5837, 0x4489AFFCE4F31A1E,
        0x2FFEEB0A48316F40, 0xDC2D9891FE68C022, 0x3659132BB12FEA70, 0xAAC17D8EFA43CAB8,
        0xC4CB815590989B13, 0x5EE975283D71C93B, 0x691548C86C1BD540, 0x7910C41D10A1E6A5,
        0x0B5FC64563B3E2A8, 0x047F7684E9FC949D, 0xB99181F2D8F685CA, 0x284600E3F30E38C3
    )

    /// A default global instance seeded with `DeviceRandom.default`.
    public static var `default` = seeded

    /// A default global instance that reseeds itself with `DeviceRandom.default`.
    public static var defaultReseeding = reseeding

    private var _state: _State

    private var _index: Int

    /// Creates an instance from `seed`.
    public init(seed: Seed) {
        _state = seed
        _index = 0
    }

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        var seed: Seed = _zero16()
        func isZero() -> Bool {
            let contents = _contents(of: &seed)
            for i in 0 ..< 16 where contents[i] != 0 {
                return false
            }
            return true
        }
        repeat {
            randomGenerator.randomize(value: &seed)
        } while isZero()
        self.init(seed: seed)
    }

    /// Returns random `Bytes`.
    public mutating func randomBytes() -> UInt64 {
        let contents = _contents(of: &_state)
        let s0 = contents[_index]
        _index = (_index &+ 1) & 15
        var s1 = contents[_index]
        s1 ^= s1 << 31
        contents[_index] = s1 ^ s0 ^ (s1 >> 11) ^ (s0 >> 30)
        return contents[_index] &* 1181783497276652981
    }

    /// Advances the generator 2^512 calls forward.
    public mutating func jump() {
        var table: _State = _zero16()
        let statePtr = _contents(of: &_state)
        let tablePtr = _contents(of: &table)
        let jumpPtr = _contents(of: &XorshiftStar._jump)
        for i in 0 ..< 16 {
            for b: UInt64 in 0 ..< 64 {
                if (jumpPtr[i] & 1) << b != 0 {
                    for j in 0 ..< 16 {
                        tablePtr[j] ^= statePtr[(j &+ _index) & 15]
                    }
                }
                _ = randomBytes()
            }
        }
        for j in 0 ..< 16 {
            statePtr[(j &+ _index) & 15] = tablePtr[j]
        }
    }

    /// Advances the generator `count` * (2^512) calls forward.
    ///
    /// - parameter count: The number of jumps to make.
    public mutating func jump(count: UInt) {
        for _ in 0 ..< count {
            jump()
        }
    }

}
