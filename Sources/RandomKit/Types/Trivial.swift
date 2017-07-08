//
//  Trivial.swift
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

/// A marker protocol demonstrating that instances of conforming types can
/// have their bits safely randomized, which allows for certain optimizations.
///
/// - warning: Conforming types **must** have no references nor spare bits. It
///   is extremely unsafe to not meet this condition.
public protocol Trivial {}

extension Int: Trivial {}
extension Int64: Trivial {}
extension Int32: Trivial {}
extension Int16: Trivial {}
extension Int8: Trivial {}
extension UInt: Trivial {}
extension UInt64: Trivial {}
extension UInt32: Trivial {}
extension UInt16: Trivial {}
extension UInt8: Trivial {}

extension Trivial where Self: Random {
    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return randomGenerator.randomUnsafeValue()
    }
}
