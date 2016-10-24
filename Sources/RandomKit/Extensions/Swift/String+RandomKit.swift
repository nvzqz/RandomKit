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
    /// - Returns: Random value within `" "..."~"` with length of `10`.
    public static func random() -> String {
        var result = ""
        for _ in 0 ..< 10 {
            result.append(Character.random())
        }
        return result
    }

    /// Generates a random `String` of a given length inside of the closed range.
    ///
    /// - parameter length: The length for the generated string. Default value is `10`.
    /// - parameter closedRange: The range within which the string will be generated.
    public static func random(ofLength length: UInt = 10, within closedRange: ClosedRange<Character>) -> String {
        var result = ""
        for _ in 0 ..< length {
            result.append(Character.random(within: closedRange))
        }
        return result
    }

    /// Generates a random `String` of a given length inside of the closed range.
    ///
    /// - parameter length: The length for the generated string. Default value is `10`.
    /// - parameter closedRange: The range within which the string will be generated.
    public static func random(ofLength length: UInt = 10, within closedRange: ClosedRange<UnicodeScalar>) -> String {
        var result = ""
        for _ in 0 ..< length {
            result.unicodeScalars.append(.random(within: closedRange))
        }
        return result
    }

}

extension String: Shuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled() -> String {
        return String(Array(characters).shuffled())
    }

}

extension String.CharacterView: Shuffleable {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffled() -> String.CharacterView {
        return String.CharacterView(Array(self).shuffled())
    }

}
