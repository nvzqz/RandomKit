//
//  Xorshift.swift
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

/// A generator that uses a [Xorshift][1] algorithm.
///
/// This implementation is taken from [XorShiftRng][2] in the Rust `rand` crate.
///
/// [1]: http://www.jstatsoft.org/v08/i14/paper
/// [2]: https://doc.rust-lang.org/rand/rand/struct.XorShiftRng.html
public struct Xorshift: RandomBytesGenerator, SeedableRandomGenerator, Random {


    /// A default global instance seeded with `DeviceRandom.default`.
    public static var `default` = seeded

    /// Returns an instance seeded with `DeviceRandom.default`.
    public static var seeded: Xorshift {
        return Xorshift(seededWith: &DeviceRandom.default)
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Xorshift {
        return Xorshift(seededWith: &randomGenerator)
    }

    private var x, y, z, w: UInt32

    /// Creates an unseeded instance.
    public init() {
        (x, y, z, w) = (0x193A6754, 0xA8A7D469, 0x97830E05, 0x113BA7BB)
    }

    /// Creates an instance from `seed`.
    ///
    /// - precondition: `seed` is nonzero.
    public init(seed: (UInt32, UInt32, UInt32, UInt32)) {
        (x, y, z, w) = seed
    }

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        var seed: Seed = (0, 0, 0, 0)
        repeat {
            randomGenerator.randomize(value: &seed)
        } while seed == (0, 0, 0, 0)
        self.init(seed: seed)
    }

    /// Returns random `Bytes`.
    public mutating func randomBytes() -> UInt32 {
        let t = x ^ (x << 11)
        x = y
        y = z
        z = w
        w = w ^ (w >> 19) ^ (t ^ (t >> 8))
        return w
    }

}
