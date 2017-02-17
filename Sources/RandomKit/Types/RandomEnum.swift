//
//  RandomEnum.swift
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

/// An enum type that can generate a random value using the last case.
///
/// As an alternative, see also `RandomWithAll`.
///
/// ```swift
/// enum Month: RandomEnum {
///
///     case january
///
///     case february
///
///     case march
///
///     case april
///
///     case may
///
///     case june
///
///     case july
///
///     case august
///
///     case september
///
///     case october
///
///     case november
///
///     case december
///
///     static let lastCase = december
///
/// }
///
/// let random = Month.random(using: &randomGenerator)  // november
/// ```
public protocol RandomEnum: Random, Hashable {

    /// The last case of `Self`.
    static var lastCase: Self { get }

}

extension RandomEnum {

    /// Generates a random value of `Self` using `randomGenerator`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        var random = UInt.random(through: UInt(lastCase.hashValue), using: &randomGenerator)
        return _unsafeCast(&random)
    }

}
