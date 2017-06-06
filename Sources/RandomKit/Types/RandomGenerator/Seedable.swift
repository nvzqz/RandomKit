//
//  Seedable.swift
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

/// A type that can be instantiated with a `Seed`.
public protocol Seedable {

    /// The seed type.
    associatedtype Seed

    /// Creates an instance from `seed`.
    init(seed: Seed)

    /// Reseeds `self` with `seed`.
    mutating func reseed(with seed: Seed)

}

extension Seedable {
    /// Reseeds `self` with `seed`.
    public mutating func reseed(with seed: Seed) {
        self = Self(seed: seed)
    }
}

/// A type that can be seeded by a sequence.
public protocol SeedableFromSequence {

    /// The seed sequence's element type.
    associatedtype SeedSequenceElement

    /// Creates an instance from `seed`.
    init<S: Sequence>(seed: S) where S.Iterator.Element == SeedSequenceElement

    /// Reseeds `self` with `seed`.
    mutating func reseed<S: Sequence>(with seed: S) where S.Iterator.Element == SeedSequenceElement

}


extension SeedableFromSequence {
    /// Reseeds `self` with `seed`.
    public mutating func reseed<S: Sequence>(with sequence: S) where S.Iterator.Element == SeedSequenceElement {
        self = Self(seed: sequence)
    }
}

/// A type that can be seeded by another `randomGenerator`.
public protocol SeedableFromRandomGenerator: Random {

    /// The default byte threshold at which `self` is reseeded in a `ReseedingRandomGenerator`.
    static var reseedingThreshold: Int { get }

    /// Creates an instance seeded with `randomGenerator`.
    init<R: RandomGenerator>(seededWith randomGenerator: inout R)

    /// Reseeds self with `randomGenerator`.
    mutating func reseed<R: RandomGenerator>(with randomGenerator: inout R)

}

extension SeedableFromRandomGenerator {

    /// The default byte threshold at which `self` is reseeded in a `ReseedingRandomGenerator` (32KB).
    public static var reseedingThreshold: Int {
        return 1024 * 32
    }

    /// Returns an instance seeded with `DeviceRandom.default`.
    public static var seeded: Self {
        return Self(seededWith: &DeviceRandom.default)
    }

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return Self(seededWith: &randomGenerator)
    }

    /// Reseeds self with `randomGenerator`.
    public mutating func reseed<R: RandomGenerator>(with randomGenerator: inout R) {
        self = Self(seededWith: &randomGenerator)
    }

    /// Reseeds self with `DeviceRandom.default`.
    public mutating func reseed() {
        reseed(with: &DeviceRandom.default)
    }

}

extension RandomGenerator where Self: SeedableFromRandomGenerator {

    /// Returns an instance that reseeds itself with `DeviceRandom.default`.
    public static var reseeding: ReseedingRandomGenerator<Self, DeviceRandom> {
        return reseeding(with: .default)
    }

    #if swift(>=3.2)

    /// Returns an instance that reseeds itself with `reseeder`.
    public static func reseeding<R>(with reseeder: R) -> ReseedingRandomGenerator<Self, R> {
        return ReseedingRandomGenerator(reseeder: reseeder)
    }

    #else

    /// Returns an instance that reseeds itself with `reseeder`.
    public static func reseeding<R: RandomGenerator>(with reseeder: R) -> ReseedingRandomGenerator<Self, R> {
        return ReseedingRandomGenerator(reseeder: reseeder)
    }

    #endif

}

extension Seedable where Self: SeedableFromRandomGenerator, Seed: Random {

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        self.init(seed: Seed.random(using: &randomGenerator))
    }

}

extension Seedable where Self: SeedableFromSequence, Seed: Sequence, Seed.Iterator.Element == Self.SeedSequenceElement {

    @inline(__always)
    private init<S: Sequence>(_seed: S) where S.Iterator.Element == SeedSequenceElement {
        self.init(seed: _seed)
    }

    /// Creates an instance from `seed`.
    public init(seed: Seed) {
        // Required to specify initializer with same argument.
        self.init(_seed: seed)
    }

    @inline(__always)
    private mutating func _reseed<S: Sequence>(with _seed: S) where S.Iterator.Element == SeedSequenceElement {
        reseed(with: _seed)
    }

    /// Reseeds `self` with `seed`.
    public mutating func reseed(with seed: Seed) {
        // Required to specify method with same name.
        _reseed(with: seed)
    }

}

extension Seedable where Self: SeedableFromSequence, Self.SeedSequenceElement == Seed {

    /// Creates an instance from `seed`.
    public init(seed: Seed) {
        self.init(seed: CollectionOfOne(seed))
    }

    /// Reseeds `self` with `seed`.
    public mutating func reseed(with seed: Seed) {
        reseed(with: CollectionOfOne(seed))
    }

}
