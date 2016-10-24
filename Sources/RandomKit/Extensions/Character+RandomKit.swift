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

import Foundation

extension Character : Random, RandomWithinClosedRange {

    /// Generates a random `Character`.
    ///
    /// - Returns: Random value within `" "..."~"`.
    public static func random() -> Character {
        return random(within: " "..."~")
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Character>) -> Character {
        var randomValue: UInt32 {
            let start   = closedRange.lowerBound.scalar.value
            let end     = closedRange.upperBound.scalar.value
            let greater = max(start, end)
            let lesser  = min(start, end)
            return lesser + arc4random_uniform(greater - lesser + 1)
        }
        return Character(UnicodeScalar(randomValue)!)
    }

    private var scalar: UnicodeScalar {
        get {
            return String(self).unicodeScalars.first!
        }
        mutating set {
            self = Character(newValue)
        }
    }

}
