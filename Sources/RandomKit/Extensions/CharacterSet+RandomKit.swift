//
//  NSCharacterSet+RandomKit.swift
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

import Foundation

extension Character {

    /// Generates a random `Character` inside of the character set.
    ///
    /// - Parameters:
    ///     - characterSet: The character set within which the character
    ///       will be generated.
    public static func random(_ characterSet: CharacterSet) -> Character? {
        return characterSet.randomCharacter
    }

}

extension String {

    /// Generates a random `String` of a given length inside of
    /// the character set.
    ///
    /// - Parameters:
    ///     - length: The length for the generated string.
    ///       Default value is `10`.
    ///     - characterSet: The character set within which the string
    ///       will be generated.
    public static func random(_ length: UInt = 10, _ characterSet: CharacterSet) -> String {
        guard length > 0 else { return "" }
        let characters = characterSet.asCharacterArray
        return (0 ..< length).reduce("") { value, _ in
            guard let character = characters.random else { return value }
            return value + String(character)
        }
    }

}

extension CharacterSet {

    /// Returns a random character from `self`, or `nil` if `self` is empty.
    public var randomCharacter: Character? {
        return self.asCharacterArray.random
    }

    fileprivate var asCharacterArray: [Character] {
        var value: [Character] = []
        for plane: UTF32Char in 0...16 {
            if self.hasMember(inPlane: UInt8(plane)) {
                var char: UTF32Char = plane << 16

                while char < (plane + 1) {
                    if let string = NSString(bytes: &char, length: 4, encoding: String.Encoding.utf32LittleEndian.rawValue) as? String, self.contains(UnicodeScalar(char)!),
                        let char: UnicodeScalar = string.unicodeScalars.first {
                        value.append(Character(char))
                    }
                    
                    char += 1
                }
            }
        }
        return value
    }

}
