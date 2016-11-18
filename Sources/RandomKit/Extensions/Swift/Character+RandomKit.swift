//
//  Character+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
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

extension Character: Random {

    /// Generates a random `Character`.
    ///
    /// - returns: Random value within `UnicodeScalar.randomRange` from `UnicodeScalar.random()`.
    public static func random(using randomGenerator: RandomGenerator) -> Character {
        return Character(UnicodeScalar.random(using: randomGenerator))
    }

    /// Returns an optional random value of `Self` inside of the range.
    public static func random(within range: Range<UnicodeScalar>,
                              using randomGenerator: RandomGenerator = .default) -> Character? {
        return UnicodeScalar.random(within: range, using: randomGenerator).map(Character.init)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<UnicodeScalar>,
                              using randomGenerator: RandomGenerator = .default) -> Character {
        return Character(UnicodeScalar.random(within: closedRange, using: randomGenerator))
    }

}
