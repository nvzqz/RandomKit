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

extension String: RandomType {

    /// Generates a random `String`.
    ///
    /// - Returns: Random value within `" "..."~"` with length of `10`.
    public static func random() -> String {
        return random(10, " "..."~")
    }

    /// Generates a random `String` of a given length inside of
    /// the closed interval.
    ///
    /// - Parameters:
    ///     - length: The length for the generated string.
    ///       Default value is `10`.
    ///     - interval: The interval within which the string
    ///       will be generated.
    public static func random(_ length: UInt = 10, _ interval: ClosedRange<Character>) -> String {
        return (0 ..< length).reduce("") { value, _ in
            value + String(Character.random(interval))
        }
    }

}

extension String: ShuffleType {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffle() -> String {
        return Array(characters).shuffle().reduce("") {
            $0 + String($1)
        }
    }

}

extension String.CharacterView: ShuffleType {

    /// Shuffles the elements in `self` and returns the result.
    public func shuffle() -> String.CharacterView {
        return String(self).shuffle().characters
    }

}
