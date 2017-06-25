//
//  ThreadLocal.swift
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
import Threadly

private let _typeMap = ThreadLocal(create: [ObjectIdentifier: AnyObject].init)

extension RandomGenerator {

    /// Returns the thread-local instance of `self` created with `create`.
    public static func threadLocal(createdWith create: () throws -> Self) rethrows -> UnsafeMutablePointer<Self> {
        let map = _typeMap.inner
        let key = ObjectIdentifier(Self.self)
        if let obj = map.value[key] {
            return UnsafeMutablePointer(&unsafeBitCast(obj, to: Box<Self>.self).value)
        } else {
            let box = try Box(create())
            map.value[key] = box
            return UnsafeMutablePointer(&box.value)
        }
    }

    /// Returns the result of performing `body` on the thread-local instance of `self` created with `create`.
    public static func withThreadLocal<T>(createdWith create: () throws -> Self, _ body: (inout Self) throws -> T) rethrows -> T {
        return try body(&threadLocal(createdWith: create).pointee)
    }

}

extension RandomGenerator where Self: SeedableFromRandomGenerator {

    /// Returns the boxed thread-local instance of `self` seeded with `DeviceRandom.default`.
    public static var threadLocal: UnsafeMutablePointer<Self> {
        return threadLocal(createdWith: { Self.seeded })
    }

    /// Returns the thread-local instance of `self` that reseeds itself with `DeviceRandom.default`.
    public static var threadLocalReseeding: UnsafeMutablePointer<ReseedingRandomGenerator<Self, DeviceRandom>> {
        return threadLocalReseeding(seededFrom: DeviceRandom.default)
    }

    #if swift(>=3.2)

    /// Returns the thread-local instance of `self` that reseeds itself with `reseeder`.
    public static func threadLocalReseeding<R>(
        seededFrom reseeder: R,
        threshold: Int = Self.reseedingThreshold
    ) -> UnsafeMutablePointer<ReseedingRandomGenerator<Self, R>> {
        return ReseedingRandomGenerator.threadLocal {
            ReseedingRandomGenerator(reseeder: reseeder, threshold: threshold)
        }
    }

    #else

    /// Returns the thread-local instance of `self` that reseeds itself with `reseeder`.
    public static func threadLocalReseeding<R: RandomGenerator>(
        seededFrom reseeder: R,
        threshold: Int = Self.reseedingThreshold
    ) -> UnsafeMutablePointer<ReseedingRandomGenerator<Self, R>> {
        return ReseedingRandomGenerator.threadLocal {
            ReseedingRandomGenerator(reseeder: reseeder, threshold: threshold)
        }
    }

    #endif

    /// Returns the result of performing `body` on the thread-local instance of `self` seeded with
    /// `DeviceRandom.default`.
    public static func withThreadLocal<T>(_ body: (inout Self) throws -> T) rethrows -> T {
        return try body(&threadLocal.pointee)
    }

    /// Returns the result of performing `body` on the thread-local instance of `self` that reseeds itself with
    /// `DeviceRandom.default`.
    public static func withThreadLocalReseeding<T>(_ body: (inout ReseedingRandomGenerator<Self, DeviceRandom>) throws -> T) rethrows -> T {
        return try body(&threadLocalReseeding.pointee)
    }

    #if swift(>=3.2)

    /// Returns the result of performing `body` on the thread-local instance of `self` that reseeds itself with
    /// `reseeder`.
    public static func withThreadLocalReseeding<R, T>(
        seededFrom reseeder: R,
        threshold: Int = Self.reseedingThreshold,
        _ body: (inout ReseedingRandomGenerator<Self, R>) throws -> T
    ) rethrows -> T {
        return try body(&threadLocalReseeding(seededFrom: reseeder, threshold: threshold).pointee)
    }

    #else

    /// Returns the result of performing `body` on the thread-local instance of `self` that reseeds itself with
    /// `reseeder`.
    public static func withThreadLocalReseeding<R: RandomGenerator, T>(
        seededFrom reseeder: R,
        threshold: Int = Self.reseedingThreshold,
        _ body: (inout ReseedingRandomGenerator<Self, R>) throws -> T
    ) rethrows -> T {
        return try body(&threadLocalReseeding(seededFrom: reseeder, threshold: threshold).pointee)
    }

    #endif

}
