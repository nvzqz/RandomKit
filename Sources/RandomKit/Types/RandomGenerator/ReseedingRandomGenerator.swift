//
//  ReseedingRandomGenerator.swift
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

/// A generator that generates values with a base generator that is reseeded by another generator.
public struct ReseedingRandomGenerator<Base: RandomGenerator & SeedableFromRandomGenerator, Reseeder: RandomGenerator> {

    fileprivate var _bytesGenerated: Int = 0

    /// The byte threshold indicating the maximum number of bytes that can be generated before `self` is reseeded.
    public var threshold: Int

    /// The base `RandomGenerator` from which to generate values.
    public var base: Base

    /// The `RandomGenerator` used to reseed `base`.
    public var reseeder: Reseeder

    /// Creates an instance with `base`, `reseeder`, and `threshold`.
    public init(base: Base, reseeder: Reseeder, threshold: Int = Base.reseedingThreshold) {
        self.base = base
        self.reseeder = reseeder
        self.threshold = max(threshold, 0)
    }

    /// Creates an instance with `reseeder` and `threshold` by instantiating `base` from `reseeder`.
    public init(reseeder: Reseeder, threshold: Int = Base.reseedingThreshold) {
        self.reseeder = reseeder
        self.base = Base(seededWith: &self.reseeder)
        self.threshold = max(threshold, 0)
    }

    /// Reseeds `self` if the number of bytes generated is greater than or equal to `threshold`. Returns `true` if
    /// `self` was reseeded
    @discardableResult
    public mutating func reseedIfNecessary() -> Bool {
        if _bytesGenerated >= threshold {
            _bytesGenerated = 0
            #if swift(>=3.2)
                var base = self.base
            #endif
            base.reseed(with: &reseeder)
            #if swift(>=3.2)
                self.base = base
            #endif
            return true
        } else {
            return false
        }
    }

}

extension ReseedingRandomGenerator where Reseeder: SeedableFromRandomGenerator {

    /// Creates an instance with `threshold` by instantiating `base` from a `Reseeder` that was in turn seeded with
    /// `DeviceRandom.default`.
    public init(threshold: Int = Base.reseedingThreshold) {
        self.init(reseeder: Reseeder.seeded, threshold: threshold)
    }

}

#if swift(>=3.1)
extension ReseedingRandomGenerator where Reseeder == DeviceRandom {

    /// Creates an instance with `threshold` by instantiating `base` from `DeviceRandom.default`.
    public init(threshold: Int = Base.reseedingThreshold) {
        self.init(reseeder: .default, threshold: threshold)
    }

}

extension ReseedingRandomGenerator where Reseeder == ARC4Random {

    /// Creates an instance with `threshold` by instantiating `base` from `ARC4Random.default`.
    public init(threshold: Int = Base.reseedingThreshold) {
        self.init(reseeder: .default, threshold: threshold)
    }

}
#endif

extension Int {
    @inline(__always)
    fileprivate func _saturatingAddPositive(_ other: Int) -> Int {
        #if swift(>=3.2)
            let (result, overflow) = addingReportingOverflow(other)
            return overflow == .overflow ? .max : result
        #else
            let (result, overflow) = Int.addWithOverflow(self, other)
            return overflow ? .max : result
        #endif
    }
}

extension ReseedingRandomGenerator: RandomGenerator {

    @inline(__always)
    private mutating func _random<T: Random>() -> T {
        reseedIfNecessary()
        _bytesGenerated = _bytesGenerated._saturatingAddPositive(MemoryLayout<T>.size)
        return T.random(using: &base)
    }

    /// Randomizes the contents of `buffer` up to `size`.
    public mutating func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        reseedIfNecessary()
        _bytesGenerated = _bytesGenerated._saturatingAddPositive(size)
        base.randomize(buffer: buffer, size: size)
    }

    /// Generates a random unsigned 64-bit integer.
    public mutating func random64() -> UInt64 {
        return _random()
    }

    /// Generates a random unsigned 32-bit integer.
    public mutating func random32() -> UInt32 {
        return _random()
    }

    /// Generates a random unsigned 16-bit integer.
    public mutating func random16() -> UInt16 {
        return _random()
    }

    /// Generates a random unsigned 8-bit integer.
    public mutating func random8() -> UInt8 {
        return _random()
    }

}
