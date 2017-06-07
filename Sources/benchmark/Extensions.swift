//
//  Extensions.swift
//  RandomKit Benchmark
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

import RandomKit

#if swift(>=3.2)

extension FixedWidthInteger {
    static var maxAdjusted: Self {
        return max - (max / 8)
    }
    static var minAdjusted: Self {
        return min - (min / 8)
    }
    static var minMaxRange: Range<Self> {
        return minAdjusted ..< maxAdjusted
    }
    static var minMaxClosedRange: ClosedRange<Self> {
        return minAdjusted ... maxAdjusted
    }
}

#else

extension Integer where Self: RandomWithMax {
    static var maxAdjusted: Self {
        return max - (max / 8)
    }
}

extension Integer where Self: RandomWithMin {
    static var minAdjusted: Self {
        return min - (min / 8)
    }
}

extension Integer where Self: RandomWithMax & RandomWithMin {
    static var minMaxRange: Range<Self> {
        return minAdjusted ..< maxAdjusted
    }
    static var minMaxClosedRange: ClosedRange<Self> {
        return minAdjusted ... maxAdjusted
    }
}

#endif

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices ~= index else {
            return nil
        }
        return self[index]
    }
}
