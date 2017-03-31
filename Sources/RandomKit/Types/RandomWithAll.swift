//
//  RandomWithAll.swift
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

/// A type that can generate a random value from a static array of all possible values of `Self`.
///
/// This makes it very easy for enum types to conform to `Random`. As an alternative, see also `RandomEnum`.
///
/// ```swift
/// enum Direction: RandomWithAll {
///
///     case north
///
///     case south
///
///     case east
///
///     case west
///
///     static let all = [north, south, east, west]
///
/// }
///
/// let random = Direction.random(using: &randomGenerator)  // east
/// ```
public protocol RandomWithAll: Random {

    /// An array of all possible values of `Self`.
    static var all: [Self] { get }

}

extension RandomWithAll {

    /// Generates a random value of `Self` using `randomGenerator`.
    ///
    /// - warning: `Self.all` should be non-empty or else this will cause a crash.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return all.uncheckedRandom(using: &randomGenerator)
    }

}
