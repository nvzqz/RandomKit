//
//  NSNumber+RandomKit.swift
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

import Foundation

extension NSNumber: Random {

    /// Generates a random number.
    ///
    /// - returns: Random value in `0...100`.
    public class func random<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        return .init(value: UInt.random(through: 100, using: &randomGenerator))
    }

    /// Generates a random integer in the closed range.
    ///
    /// - parameter closedRange: The range in which the integer will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public class func random<R: RandomGenerator>(in closedRange: ClosedRange<Int>, using randomGenerator: inout R) -> Self {
        return .init(value: .random(in: closedRange, using: &randomGenerator))
    }

    /// Generates a random double in the closed range.
    ///
    /// - parameter closedRange: The range in which the double will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public class func random<R: RandomGenerator>(in closedRange: ClosedRange<Double>, using randomGenerator: inout R) -> Self {
        return .init(value: .random(in: closedRange, using: &randomGenerator))
    }

}

