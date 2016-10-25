//
//  String+RandomKit.swift
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

extension String: Random {

    /// Generates a random `String`.
    ///
    /// - returns: Random value within `" "..."~"` with length of `10`.
    public static func random(using randomGenerator: RandomGenerator) -> String {
        var result = ""
        for _ in 0 ..< 10 {
            result.append(Character.random(using: randomGenerator))
        }
        return result
    }

    /// Generates a random `String` of a given length inside of the range.
    ///
    /// - parameter length: The length for the generated string. Default value is `10`.
    /// - parameter range: The range within which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random(ofLength length: UInt = 10,
                              within range: Range<UnicodeScalar>,
                              using randomGenerator: RandomGenerator = .default) -> String? {
        var result = ""
        for _ in 0 ..< length {
            guard let scalar = UnicodeScalar.random(within: range) else {
                return nil
            }
            result.unicodeScalars.append(scalar)
        }
        return result
    }

    /// Generates a random `String` of a given length inside of the closed range.
    ///
    /// - parameter length: The length for the generated string. Default value is `10`.
    /// - parameter closedRange: The range within which the string will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random(ofLength length: UInt = 10,
                              within closedRange: ClosedRange<UnicodeScalar>,
                              using randomGenerator: RandomGenerator = .default) -> String {
        var result = ""
        for _ in 0 ..< length {
            result.unicodeScalars.append(.random(within: closedRange, using: randomGenerator))
        }
        return result
    }

}

extension String: Shuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled(using randomGenerator: RandomGenerator) -> String {
        return String(Array(characters).shuffled(using: randomGenerator))
    }

}

extension String.CharacterView: Shuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled(using randomGenerator: RandomGenerator) -> String.CharacterView {
        return String.CharacterView(Array(self).shuffled(using: randomGenerator))
    }

}
