//
//  CGFloat+RandomKit.swift
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

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

import CoreGraphics

extension CGFloat: Random, RandomToValue, RandomThroughValue, RandomWithinRange, RandomWithinClosedRange {

    /// Generates a random `CGFloat` within the closed range using `randomGenerator`.
    ///
    /// - parameter closedRange: The range within which the number will be generated.
    /// - parameter randomGenerator: The random generator to use.
    public static func random<R: RandomGenerator>(within closedRange: ClosedRange<NativeType>, using randomGenerator: inout R) -> CGFloat {
        return CGFloat(NativeType.random(within: closedRange, using: &randomGenerator))
    }

}

#endif
