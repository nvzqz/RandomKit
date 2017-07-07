//
//  RandomKitTests.swift
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

class RandomKitTests: XCTestCase {

    static let allTests = [("testRandomInt", testRandomInt),
                           ("testRandomHalfOpenEdgeCase", testRandomHalfOpenEdgeCase),
                           ("testRandomClosedEdgeCase", testRandomClosedEdgeCase),
                           ("testRandomOpenEdgeCase", testRandomOpenEdgeCase),
                           ("testRandomOpen", testRandomOpen),
                           ("testRandomClosed", testRandomClosed),
                           ("testRandomDouble", testRandomDouble),
                           ("testRandomFloat", testRandomFloat),
                           ("testRandomBool", testRandomBool),
                           ("testRandoms", testRandoms),
                           ("testRandomArray", testRandomArray),
                           ("testRandomSet", testRandomSet),
                           ("testRandomDictionary", testRandomDictionary),
                           ("testRandomArraySlice", testRandomArraySlice)]

    static let generatorToTest = Xoroshiro.self

    let testCount = 100_000

    func testRandomInt() {
        RandomKitTests.generatorToTest.withThreadLocal { rng in
            for max in stride(from: 1, through: Int.max - 128, by: Int.max / 128) {
                for _ in 0 ..< testCount / 128 {
                    let range = (-max)...max
                    let num = Int.random(in: range, using: &rng)
                    XCTAssertTrue(range ~= num, "\(num) is out of bounds of \(range).")
                }
            }
        }
    }

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

    func testRandomOpen() {
        func test<F: Comparable & ExpressibleByFloatLiteral>(with value: F) {
            XCTAssertGreaterThan(value, 0.0)
            XCTAssertLessThan(value, 1.0)
        }
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            for _ in 0 ..< testCount {
                test(with: gen.randomOpen32())
                test(with: gen.randomOpen64())
            }
        }
    }

    func testRandomClosed() {
        func test<F: Comparable & ExpressibleByFloatLiteral>(with value: F) {
            XCTAssertGreaterThanOrEqual(value, 0.0)
            XCTAssertLessThanOrEqual(value, 1.0)
        }
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            for _ in 0 ..< testCount {
                test(with: gen.randomClosed32())
                test(with: gen.randomClosed64())
            }
        }
    }

    func testRandomDouble() {
        let min = -1.5
        let max =  0.5
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            for _ in 0 ..< testCount {
                let r = Double.random(in: min...max, using: &gen)
                XCTAssertTrue(r >= min && r <= max, "Random `Double` is out of bounds.")
            }
        }
    }

    func testRandomFloat() {
        let min: Float = -1.5
        let max: Float =  0.5
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            for _ in 0 ..< testCount {
                let r = Float.random(in: min...max, using: &gen)
                XCTAssertTrue(r >= min && r <= max, "Random `Float` is out of bounds.")
            }
        }
    }

    func testRandomBool() {
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            let falseCount = (0 ..< testCount).reduce(0) { count, _ in
                Bool.random(using: &gen) ? count : count + 1
            }
            let difference = 0.5
            let percentRange = (50 - difference)...(50 + difference)
            let percentFalse = Double(falseCount) / Double(testCount) * 100
            XCTAssertTrue(percentRange ~= percentFalse, "One happens more often than the other.")
        }
    }

    func testRandoms() {
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            do {
                var iter = Int.randoms(using: &gen)
                for _ in 0...10 {
                    XCTAssertNotNil(iter.next())
                }
            }
            do {
                let c = 10
                var i = 0
                var a = [Int]()
                for v in Int.randoms(using: &gen) {
                    defer { i += 1 }

                    if i >= c { break }
                    a.append(v)
                }
                XCTAssertEqual(a.count, c)
            }
            do {
                var i = 0
                let c = 10
                var iter = Int.randoms(limitedBy: c, using: &gen)
                while let _ = iter.next() {
                    i += 1
                }
                XCTAssertEqual(i, c)
            }
            do {
                let c = 10
                let s = Int.randoms(limitedBy: c, using: &gen)
                XCTAssertEqual(Array(s).count, c)
            }
        }
    }

    func testRandomArray() {
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            let array: [Int] = Array(randomCount: 10, using: &gen)
            XCTAssertEqual(array.count, 10)
        }
    }

    func testRandomSet() {
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            let set = Set<Int>(randomCount: 10, using: &gen)
            XCTAssertEqual(set.count, 10)
        }
    }

    func testRandomDictionary() {
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            let dict = [Int : String](randomCount: 10, using: &gen)
            XCTAssertEqual(dict.count, 10)
        }
    }

    func testRandomArraySlice() {
        RandomKitTests.generatorToTest.withThreadLocal { gen in
            let count = 10
            let array: [Int] = Array(randomCount: count, using: &gen)
            let sliceCount = count / 2

            var result = array.randomSlice(count: sliceCount, using: &gen)
            XCTAssertEqual(result.count, sliceCount)
            let simpleSlice = Array(array[0..<sliceCount])
            XCTAssertNotEqual(result, simpleSlice)

            result = array.randomSlice(count: count, using: &gen) // all
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: count * 2, using: &gen) // too much
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: 0, using: &gen) // nothing
            XCTAssertEqual(result.count, 0)

            let weightsArray: [[Double]] = [
                Array(randomCount: count, using: &gen),
                Array(randomCount: count, in: 0...100, using: &gen)
            ]

            for weights in weightsArray {
                result = array.randomSlice(count: count, weights: weights, using: &gen) // all
                XCTAssertEqual(result.count, count)

                result = array.randomSlice(count: sliceCount, weights: weights, using: &gen)
                XCTAssertEqual(result.count, sliceCount)
                //let simpleSlice = Array(array[0..<sliceCount])
                // XCTAssertNotEqual(result, simpleSlice) // cannot be sure, depends and weights

                result = array.randomSlice(count: count * 2,
                                           weights: weights,
                                           using: &gen) // too much
                XCTAssertEqual(result.count, count)

                result = array.randomSlice(count: count * 2,
                                           weights: Array(randomCount: count / 2, using: &gen),
                                           using: &gen) // partial weights
                XCTAssertEqual(result.count, count)
                
                result = array.randomSlice(count: 0, weights: weights, using: &gen) // nothing
                XCTAssertEqual(result.count, 0)
            }
        }
    }

    // MARK: utils

    private func roundToPlaces(_ value: Double, places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }

    private func round10(_ value: Double) -> Double {
        return roundToPlaces(value, places: 10)
    }

    private func discretMoment(_ array: [Int]) -> (mean: Double, variance: Double) {
        let dCount = Double(array.count)
        let mean = Double(array.reduce(0, +)) / dCount
        let varianceSum = { (current: Double, val: Int) in
            current + (Double(val) - mean) * (Double(val) - mean)
        }
        let variance = array.reduce(0.0, varianceSum) / dCount

        return (mean: mean, variance: variance)
    }

    var discretAccuracy = 0.007
}
