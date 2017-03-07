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

class RandomKitTests: XCTestCase {

    static let allTests = [("testRandomInt", testRandomInt),
                           ("testRandomDouble", testRandomDouble),
                           ("testRandomFloat", testRandomFloat),
                           ("testRandomBool", testRandomBool),
                           ("testRandomCharacter", testRandomCharacter),
                           ("testRandomString", testRandomString),
                           ("testRandomFromArrayTime", testRandomFromArrayTime),
                           ("testRandomFromSetTime", testRandomFromSetTime),
                           ("testRandomFromDictTime", testRandomFromDictTime),
                           ("testRandomFromCollectionType", testRandomFromCollectionType),
                           ("testArrayShuffleTime", testArrayShuffleTime),
                           ("testDictionaryShuffleTime", testDictionaryShuffleTime),
                           ("testStringShuffleTime", testStringShuffleTime),
                           ("testRandoms", testRandoms),
                           ("testRandomArray", testRandomArray),
                           ("testRandomSet", testRandomSet),
                           ("testRandomDictionary", testRandomDictionary),
                           ("testRandomArraySlice", testRandomArraySlice)]

    static var generatorToTest = Xoroshiro.default

    let testCount = 100_000

    func testRandomInt() {
        let min = -10
        let max =  10
        for _ in 0...testCount {
            let r = Int.random(within: min...max, using: &RandomKitTests.generatorToTest)
            XCTAssertTrue(r >= min && r <= max, "Random `Int` is out of bounds.")
        }
    }

    func testRandomDouble() {
        let min = -1.5
        let max =  0.5
        for _ in 0...testCount {
            let r = Double.random(within: min...max, using: &RandomKitTests.generatorToTest)
            XCTAssertTrue(r >= min && r <= max, "Random `Double` is out of bounds.")
        }
    }

    func testRandomFloat() {
        let min: Float = -1.5
        let max: Float =  0.5
        for _ in 0...testCount {
            let r = Float.random(within: min...max, using: &RandomKitTests.generatorToTest)
            XCTAssertTrue(r >= min && r <= max, "Random `Float` is out of bounds.")
        }
    }

    func testRandomBool() {
        let falseCount = (0 ..< testCount).reduce(0) { count, _ in
            Bool.random(using: &RandomKitTests.generatorToTest) ? count : count + 1
        }
        let difference = 0.25
        let percentRange = (50 - difference)...(50 + difference)
        let percentFalse = Double(falseCount) / Double(testCount) * 100
        XCTAssertTrue(percentRange ~= percentFalse, "One happens more often than the other.")
    }

    let min: UnicodeScalar = .init(0)
    let max: UnicodeScalar = .init(.max)

    var range: ClosedRange<UnicodeScalar> { return min...max }

    func testRandomCharacter() {
        let sameCount = (0...testCount).reduce(0) { count, _ in
            let r1 = Character.random(within: self.range, using: &RandomKitTests.generatorToTest)
            let r2 = Character.random(within: self.range, using: &RandomKitTests.generatorToTest)
            return count + (r1 == r2 ? 1 : 0)
        }
        XCTAssertFalse(sameCount > testCount / 100, "Too many equal random characters")
    }

    func testRandomString() {
        let sameCount = (0...(testCount/2)).reduce(0) { count, _ in
            let r1 = String.random(ofLength: 10, within: range, using: &RandomKitTests.generatorToTest)
            let r2 = String.random(ofLength: 10, within: range, using: &RandomKitTests.generatorToTest)
            return count + (r1 == r2 ? 1 : 0)
        }
        XCTAssertFalse(sameCount > 1, "Too many equal random strings")
    }

    func testRandomFromArrayTime() {
        let arr = Array(0 ..< 10000)
        self.measure {
            XCTAssertNotNil(arr.random(using: &RandomKitTests.generatorToTest))
        }
    }

    func testRandomFromSetTime() {
        let set = Set(0 ..< 10000)
        self.measure {
            XCTAssertNotNil(set.random(using: &RandomKitTests.generatorToTest))
        }
    }

    func testRandomFromDictTime() {
        let dict: [Int : Int] = RandomKitTests.randomDictionaryOfCount(10000)

        NSLog("done with making dict")
        self.measure {
            XCTAssertNotNil(dict.random(using: &RandomKitTests.generatorToTest))
        }
    }

    func testRandomFromCollectionType() {
        let arr = ["A", "B", "C", "D", "E", "F", "H", "I"]
        let dict = ["k1" : "v1", "k2" : "v2", "k3" : "v3"]
        for _ in 0...testCount {
            XCTAssertNotNil(arr.random(using: &RandomKitTests.generatorToTest),
                            "Random element in non-empty array is nil")
            XCTAssertNotNil(dict.random(using: &RandomKitTests.generatorToTest),
                            "Random element in non-empty dictionary is nil")
        }
    }

    func testArrayShuffleTime() {
        let a1: [Int] = (0 ..< 10000).reduce([]) { $0 + [$1] }
        var a2: [Int] = []
        self.measure {
            a2 = a1.shuffled(using: &RandomKitTests.generatorToTest)
        }
        XCTAssertNotEqual(a1, a2)
    }

    func testDictionaryShuffleTime() {
        let d1: [Int : Int] = RandomKitTests.randomDictionaryOfCount(1000)
        var d2: [Int : Int] = [:]
        self.measure {
            d2 = d1.shuffled(using: &RandomKitTests.generatorToTest)
        }
        XCTAssertNotEqual(d1, d2)
    }

    func testStringShuffleTime() {
        let str1 = (0 ..< 10000).reduce("") { str, _ in
            str + String(Int.random(within: 0...9, using: &RandomKitTests.generatorToTest))
        }
        var str2 = ""
        self.measure {
            str2 = str1.shuffled(using: &RandomKitTests.generatorToTest)
        }
        XCTAssertNotEqual(str1, str2)
    }

    func testRandoms() {
        do {
            var iter = Int.randoms(using: &RandomKitTests.generatorToTest)
            for _ in 0...10 {
                XCTAssertNotNil(iter.next())
            }
        }
        do {
            let c = 10
            var i = 0
            var a = [Int]()
            for v in Int.randoms(using: &RandomKitTests.generatorToTest) {
                defer { i += 1 }

                if i >= c { break }
                a.append(v)
            }
            XCTAssertEqual(a.count, c)
        }
        do {
            var i = 0
            let c = 10
            var iter = Int.randoms(limitedBy: c, using: &RandomKitTests.generatorToTest)
            while let _ = iter.next() {
                i += 1
            }
            XCTAssertEqual(i, c)
        }
        do {
            let c = 10
            let s = Int.randoms(limitedBy: c, using: &RandomKitTests.generatorToTest)
            XCTAssertEqual(Array(s).count, c)
        }
    }

    func testRandomArray() {
        let array: [Int] = Array(randomCount: 10, using: &RandomKitTests.generatorToTest)
        XCTAssertEqual(array.count, 10)
    }

    func testRandomSet() {
        let set = Set<Int>(randomCount: 10, using: &RandomKitTests.generatorToTest)
        XCTAssertEqual(set.count, 10)
    }

    func testRandomDictionary() {
        let dict: [Int : String] = Dictionary(randomCount: 10, using: &RandomKitTests.generatorToTest)
        XCTAssertEqual(dict.count, 10)
    }

    func testRandomArraySlice() {
        let count = 10
        let array: [Int] = Array(randomCount: count, using: &RandomKitTests.generatorToTest)
        let sliceCount = count / 2

        var result = array.randomSlice(count: sliceCount, using: &RandomKitTests.generatorToTest)
        XCTAssertEqual(result.count, sliceCount)
        let simpleSlice = Array(array[0..<sliceCount])
        XCTAssertNotEqual(result, simpleSlice)

        result = array.randomSlice(count: count, using: &RandomKitTests.generatorToTest) // all
        XCTAssertEqual(result.count, count)

        result = array.randomSlice(count: count * 2, using: &RandomKitTests.generatorToTest) // too much
        XCTAssertEqual(result.count, count)

        result = array.randomSlice(count: 0, using: &RandomKitTests.generatorToTest) // nothing
        XCTAssertEqual(result.count, 0)

        let weightsArray: [[Double]] = [
            Array(randomCount: count, using: &RandomKitTests.generatorToTest),
            Array(randomCount: count, within: 0...100, using: &RandomKitTests.generatorToTest)
        ]

        for weights in weightsArray {
            result = array.randomSlice(count: count, weights: weights, using: &RandomKitTests.generatorToTest) // all
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: sliceCount, weights: weights, using: &RandomKitTests.generatorToTest)
            XCTAssertEqual(result.count, sliceCount)
            //let simpleSlice = Array(array[0..<sliceCount])
            // XCTAssertNotEqual(result, simpleSlice) // cannot be sure, depends and weights

            result = array.randomSlice(count: count * 2,
                                       weights: weights,
                                       using: &RandomKitTests.generatorToTest) // too much
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: count * 2,
                                       weights: Array(randomCount: count / 2, using: &RandomKitTests.generatorToTest),
                                       using: &RandomKitTests.generatorToTest) // partial weights
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: 0, weights: weights, using: &RandomKitTests.generatorToTest) // nothing
            XCTAssertEqual(result.count, 0)
        }
    }

    // MARK: utils

    private static func randomDictionaryOfCount(_ count: Int) -> [Int : Int] {
        return (0 ..< count).reduce(Dictionary(minimumCapacity: count)) { (dict, num) in
            var mutableDict = dict

            mutableDict[num] = num
            return mutableDict
        }
    }

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
