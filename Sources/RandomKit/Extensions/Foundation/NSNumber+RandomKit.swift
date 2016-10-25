//
//  NSNumber+RandomKit.swift
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

extension NSNumber: Random {

    /// Generates a random number.
    ///
    /// - returns: Random value within `0...100`.
    public class func random(using randomGenerator: RandomGenerator) -> Self {
        return random(within: 0...100, using: randomGenerator)
    }

    /// Generates a random integer within the closed range.
    ///
    /// - parameter closedRange: The range within which the integer will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public class func random(within closedRange: ClosedRange<Int>,
                             using randomGenerator: RandomGenerator = .default) -> Self {
        return .init(value: .random(within: closedRange, using: randomGenerator))
    }

    /// Generates a random double within the closed range.
    ///
    /// - parameter closedRange: The range within which the double will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public class func random(within closedRange: ClosedRange<Double>,
                             using randomGenerator: RandomGenerator = .default) -> Self {
        return .init(value: .random(within: closedRange, using: randomGenerator))
    }

}

