//
//  String+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolai Vazquez
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

    /// The default length for randomly generated strings.
    public static var RandomLength: UInt = 10

    /// Generates a random `String`.
    ///
    /// - Returns: Random value within `" "..."~"` with length of `RandomLength`.
    public static func random() -> String {
        return random(RandomLength, " "..."~")
    }

    /// Generates a random `String` of a given length inside of
    /// the closed interval.
    ///
    /// - Parameters:
    ///     - length: The length for the generated string.
    ///       Default value is `RandomLength`.
    ///     - interval: The interval within which the string
    ///       will be generated.
    public static func random(length: UInt = RandomLength, _ interval: ClosedInterval<Character>) -> String {
        return (0 ..< length).reduce("") { value, _ in
            value + String(Character.random(interval))
        }
    }

}
