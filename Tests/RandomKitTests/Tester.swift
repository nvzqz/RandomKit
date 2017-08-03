//
//  Tester.swift
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
import RandomKit

let defaultTestCount: UInt = 100_000

public protocol Tester {
    associatedtype Gen: RandomGenerator

    func withTestGenerator(_ body: (UnsafeMutablePointer<Gen>) throws -> ()) rethrows

    func testRandomInt()
    func testRandomOpen()
    func testRandomClosed()
    func testRandomDouble()
    func testRandomFloat()
    func testRandomBool()
    func testRandomArraySlice()
}

extension Tester {

    static var tests: [(String, (Self) -> () -> ())] {
        return [("testRandomInt", testRandomInt),
                ("testRandomOpen", testRandomOpen),
                ("testRandomClosed", testRandomClosed),
                ("testRandomDouble", testRandomDouble),
                ("testRandomFloat", testRandomFloat),
                ("testRandomBool", testRandomBool),
                ("testRandomArraySlice", testRandomArraySlice)]
    }

    func testRandomInt(count: UInt) {
        withTestGenerator { gen in
            for max in stride(from: 1, through: Int.max - 128, by: Int.max / 128) {
                let range = (-max)...max
                for _ in 0 ..< count / 128 {
                    let num = Int.random(in: range, using: &gen.pointee)
                    XCTAssertTrue(range ~= num, "\(num) is out of bounds of \(range).")
                }
            }
        }
    }

    func testRandomOpen(count: UInt) {
        withTestGenerator { gen in
            func test<F: Comparable & ExpressibleByFloatLiteral>(with value: F) {
                XCTAssertGreaterThan(value, 0.0)
                XCTAssertLessThan(value, 1.0)
            }
            for _ in 0 ..< count {
                test(with: gen.pointee.randomOpen32())
                test(with: gen.pointee.randomOpen64())
            }
        }
    }

    func testRandomClosed(count: UInt) {
        withTestGenerator { gen in
            func test<F: Comparable & ExpressibleByFloatLiteral>(with value: F) {
                XCTAssertGreaterThanOrEqual(value, 0.0)
                XCTAssertLessThanOrEqual(value, 1.0)
            }
            for _ in 0 ..< count {
                test(with: gen.pointee.randomClosed32())
                test(with: gen.pointee.randomClosed64())
            }
        }
    }

    func testRandomDouble(count: UInt) {
        withTestGenerator { gen in
            let min = -1.5
            let max =  0.5
            for _ in 0 ..< count {
                let r = Double.random(in: min...max, using: &gen.pointee)
                XCTAssertTrue(r >= min && r <= max, "Random `Double` is out of bounds.")
            }
        }
    }

    func testRandomFloat(count: UInt) {
        withTestGenerator { gen in
            let min: Float = -1.5
            let max: Float =  0.5
            for _ in 0 ..< count {
                let r = Float.random(in: min...max, using: &gen.pointee)
                XCTAssertTrue(r >= min && r <= max, "Random `Float` is out of bounds.")
            }
        }
    }

    func testRandomBool(count: UInt) {
        withTestGenerator { gen in
            let falseCount = (0 ..< count).reduce(0) { count, _ in
                Bool.random(using: &gen.pointee) ? count : count + 1
            }
            let difference = 0.5
            let percentRange = (50 - difference)...(50 + difference)
            let percentFalse = Double(falseCount) / Double(defaultTestCount) * 100
            XCTAssertTrue(percentRange ~= percentFalse, "One happens more often than the other.")
        }
    }

    func testRandomArraySliceImpl() {
        withTestGenerator { gen in
            let count = 10
            let array: [Int] = Array(randomCount: count, using: &gen.pointee)
            let sliceCount = count / 2

            var result = array.randomSlice(count: sliceCount, using: &gen.pointee)
            XCTAssertEqual(result.count, sliceCount)
            let simpleSlice = Array(array[0..<sliceCount])
            XCTAssertNotEqual(result, simpleSlice)

            result = array.randomSlice(count: count, using: &gen.pointee) // all
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: count * 2, using: &gen.pointee) // too much
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: 0, using: &gen.pointee) // nothing
            XCTAssertEqual(result.count, 0)

            let weightsArray: [[Double]] = [
                Array(randomCount: count, using: &gen.pointee),
                Array(randomCount: count, in: 0...100, using: &gen.pointee)
            ]

            for weights in weightsArray {
                result = array.randomSlice(count: count, weights: weights, using: &gen.pointee) // all
                XCTAssertEqual(result.count, count)

                result = array.randomSlice(count: sliceCount, weights: weights, using: &gen.pointee)
                XCTAssertEqual(result.count, sliceCount)

                result = array.randomSlice(count: count * 2,
                                           weights: weights,
                                           using: &gen.pointee) // too much
                XCTAssertEqual(result.count, count)

                result = array.randomSlice(count: count * 2,
                                           weights: Array(randomCount: count / 2, using: &gen.pointee),
                                           using: &gen.pointee) // partial weights
                XCTAssertEqual(result.count, count)

                result = array.randomSlice(count: 0, weights: weights, using: &gen.pointee) // nothing
                XCTAssertEqual(result.count, 0)
            }
        }
    }

}

extension Tester where Gen: SeedableFromRandomGenerator {
    func withTestGenerator(_ body: (UnsafeMutablePointer<Gen>) throws -> ()) rethrows {
        try body(&Gen.threadLocal.value)
    }
}
