//
//  ConstantTests.swift
//  RandomKitTests
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

import XCTest
import Foundation
import RandomKit

struct ConstantRandomGenerator: RandomBytesGenerator {
    var value: UInt64
    mutating func randomBytes() -> UInt64 {
        return value
    }
}

class ConstantTests: XCTestCase {

    static let allTests = [("testRandomHalfOpenEdgeCase", testRandomHalfOpenEdgeCase),
                           ("testRandomClosedEdgeCase", testRandomClosedEdgeCase),
                           ("testRandomOpenEdgeCase", testRandomOpenEdgeCase)]

    static let generatorToTest = Xoroshiro.self

    let testCount: UInt = 100_000

    func testRandomHalfOpenEdgeCase() {
        var gen = ConstantRandomGenerator(value: .max)
        XCTAssertNotEqual(gen.randomHalfOpen32(), 1.0)
        XCTAssertNotEqual(gen.randomHalfOpen64(), 1.0)
    }

    func testRandomClosedEdgeCase() {
        var gen = ConstantRandomGenerator(value: .max)
        XCTAssertEqual(gen.randomClosed32(), 1.0)
        XCTAssertEqual(gen.randomClosed64(), 1.0)
    }

    func testRandomOpenEdgeCase() {
        var gen = ConstantRandomGenerator(value: 0)
        XCTAssertNotEqual(gen.randomOpen32(), 0.0)
        XCTAssertNotEqual(gen.randomOpen64(), 0.0)
    }

}
