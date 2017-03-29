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

private final class _Box<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}

private var _keys = [ObjectIdentifier: pthread_key_t]()

private func _key<T>(for _: T.Type) -> pthread_key_t {
    let id = ObjectIdentifier(T.self)
    if let key = _keys[id] {
        return key
    } else {
        var key = pthread_key_t()
        pthread_key_create(&key) {
            guard let rawPointer = ($0 as UnsafeMutableRawPointer?) else {
                return
            }
            Unmanaged<AnyObject>.fromOpaque(rawPointer).release()
        }
        _keys[id] = key
        return key
    }
}

extension RandomGenerator {

    /// Returns the thread-local instance of `self` created with `create`.
    public static func threadLocal(createdWith create: () throws -> Self) rethrows -> UnsafeMutablePointer<Self> {
        let unmanaged: Unmanaged<_Box<Self>>
        let key = _key(for: Self.self)
        if let pointer = pthread_getspecific(key) {
            unmanaged = Unmanaged.fromOpaque(pointer)
        } else {
            unmanaged = Unmanaged.passRetained(_Box(try create()))
            pthread_setspecific(key, unmanaged.toOpaque())
        }
        return UnsafeMutablePointer(&unmanaged.takeUnretainedValue().value)
    }

    /// Returns the result of performing `body` on the thread-local instance of `self` created with `create`.
    public static func withThreadLocal<T>(createdWith create: () throws -> Self, _ body: (inout Self) throws -> T) rethrows -> T {
        return try body(&threadLocal(createdWith: create).pointee)
    }

}

extension SeedableFromOtherRandomGenerator {

    /// Returns the boxed thread-local instance of `self` seeded with `DeviceRandom.default`.
    public static var threadLocal: UnsafeMutablePointer<Self> {
        return threadLocal(createdWith: { Self.seeded })
    }

    /// Returns the thread-local instance of `self` that reseeds itself with `DeviceRandom.default`.
    public static var threadLocalReseeding: UnsafeMutablePointer<ReseedingRandomGenerator<Self, DeviceRandom>> {
        return ReseedingRandomGenerator.threadLocal(createdWith: { Self.reseeding })
    }

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

}
