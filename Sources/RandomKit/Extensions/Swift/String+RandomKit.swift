//
//  String+RandomKit.swift
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

extension String: Random {

    /// Generates a random `String`.
    ///
    /// - returns: Random value in `UnicodeScalar.randomRange` with length of `10`.
    public static func random<R: RandomGenerator>(using randomGenerator: inout R) -> String {
        return random(ofLength: 10, in: UnicodeScalar.randomRange, using: &randomGenerator)
    }

    /// Generates a random `String` with a length of `10` inside of the range.
    ///
    /// - parameter range: The range in which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(in range: Range<UnicodeScalar>,
                              using randomGenerator: inout R) -> String? {
        return random(ofLength: 10, in: range, using: &randomGenerator)
    }

    /// Generates a random `String` of a given length inside of the range.
    ///
    /// - parameter length: The length for the generated string.
    /// - parameter range: The range in which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<I: ExpressibleByIntegerLiteral & Strideable, R: RandomGenerator>(ofLength length: I,
                              in range: Range<UnicodeScalar>,
                              using randomGenerator: inout R) -> String? where I.Stride: SignedInteger {
        if range.isEmpty {
            return nil
        }
        var result = UnicodeScalarView()
        for _ in 0 ..< length {
            result.append(UnicodeScalar.uncheckedRandom(in: range, using: &randomGenerator))
        }
        return String(result)
    }

    /// Generates a random `String` with a length of `10` inside of the closed range.
    ///
    /// - parameter closedRange: The range in which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(in closedRange: ClosedRange<UnicodeScalar>,
                              using randomGenerator: inout R) -> String {
        return random(ofLength: 10, in: closedRange, using: &randomGenerator)
    }

    /// Generates a random `String` of a given length inside of the closed range.
    ///
    /// - parameter length: The length for the generated string.
    /// - parameter closedRange: The range in which the string will be generated. The default is `UnicodeScalar.randomRange`.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<I: ExpressibleByIntegerLiteral & Strideable, R: RandomGenerator>(ofLength length: I,
                              in closedRange: ClosedRange<UnicodeScalar> = UnicodeScalar.randomRange,
                              using randomGenerator: inout R) -> String where I.Stride: SignedInteger {
        var result = UnicodeScalarView()
        for _ in 0 ..< length {
            result.append(.random(in: closedRange, using: &randomGenerator))
        }
        return String(result)
    }

    /// Generates a random `String` with a length of `10` from `characters`.
    ///
    /// - parameter characters: The characters from which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(from characters: CharacterView,
                              using randomGenerator: inout R) -> String? {
        return random(ofLength: 10, from: characters, using: &randomGenerator)
    }

    /// Generates a random `String` of a given length from `characters`.
    ///
    /// - parameter length: The length for the generated string.
    /// - parameter characters: The characters from which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<I: ExpressibleByIntegerLiteral & Strideable, R: RandomGenerator>(ofLength length: I,
                              from characters: CharacterView,
                              using randomGenerator: inout R) -> String? where I.Stride: SignedInteger {
        var result = ""
        for _ in 0 ..< length {
            guard let random = characters.random(using: &randomGenerator) else {
                return nil
            }
            result.append(random)
        }
        return result
    }

    /// Generates a random `String` with a length of `10` from `scalars`.
    ///
    /// - parameter scalars: The unicode scalars from which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(from scalars: UnicodeScalarView,
                              using randomGenerator: inout R) -> String? {
        return random(ofLength: 10, from: scalars, using: &randomGenerator)
    }

    /// Generates a random `String` of a given length from `scalars`.
    ///
    /// - parameter length: The length for the generated string.
    /// - parameter scalars: The unicode scalars from which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<I: ExpressibleByIntegerLiteral & Strideable, R: RandomGenerator>(ofLength length: I,
                              from scalars: UnicodeScalarView,
                              using randomGenerator: inout R) -> String? where I.Stride: SignedInteger {
        var result = UnicodeScalarView()
        for _ in 0 ..< length {
            guard let random = scalars.random(using: &randomGenerator) else {
                return nil
            }
            result.append(random)
        }
        return String(result)
    }

    /// Generates a random `String` with a length of `10` from characters in `string`.
    ///
    /// - parameter string: The string whose characters from which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(from string: String,
                              using randomGenerator: inout R) -> String? {
        return random(ofLength: 10, from: string, using: &randomGenerator)
    }

    /// Generates a random `String` of a given length from characters in `string`.
    ///
    /// - parameter length: The length for the generated string.
    /// - parameter string: The string whose characters from which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<I: ExpressibleByIntegerLiteral & Strideable, R: RandomGenerator>(ofLength length: I,
                              from string: String,
                              using randomGenerator: inout R) -> String? where I.Stride: SignedInteger {
        return random(ofLength: length, from: string.characters, using: &randomGenerator)
    }

}

extension String.UnicodeScalarView: RandomRetrievableInRange {}
extension String.CharacterView: RandomRetrievableInRange {}
extension String.UTF8View: RandomRetrievableInRange {}
extension String.UTF16View: RandomRetrievableInRange {}

extension String: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> String {
        return String(Array(characters).shuffled(using: &randomGenerator))
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> String {
        return String(Array(characters).shuffledUnique(using: &randomGenerator))
    }

}

extension String.CharacterView: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> String.CharacterView {
        return String.CharacterView(Array(self).shuffled(using: &randomGenerator))
    }

    /// Shuffles the elements in `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> String.CharacterView {
        return String.CharacterView(Array(self).shuffledUnique(using: &randomGenerator))
    }

}
