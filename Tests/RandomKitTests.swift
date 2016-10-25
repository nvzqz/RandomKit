//
//  RandomKitTests.swift
//  RandomKitTests
//
//  Created by Nikolai Vazquez on 10/10/15.
//  Copyright © 2015 Nikolai Vazquez. All rights reserved.
//

import XCTest
import RandomKit

class RandomKitTests: XCTestCase {

    let testCount = 1_000_000

    func testRandomInt() {
        let min = -10
        let max =  10
        for _ in 0...testCount {
            let r = Int.random(within: min...max)
            XCTAssertTrue(r >= min && r <= max, "Random `Int` is out of bounds.")
        }
    }

    func testRandomDouble() {
        let min = -1.5
        let max =  0.5
        for _ in 0...testCount {
            let r = Double.random(within: min...max)
            XCTAssertTrue(r >= min && r <= max, "Random `Double` is out of bounds.")
        }
    }

    func testRandomFloat() {
        let min: Float = -1.5
        let max: Float =  0.5
        for _ in 0...testCount {
            let r = Float.random(within: min...max)
            XCTAssertTrue(r >= min && r <= max, "Random `Float` is out of bounds.")
        }
    }

    func testRandomBool() {
        let falseCount = (0...testCount).reduce(0) { count, _ in
            Bool.random() ? count : count + 1
        }
        let difference = 0.25
        let percentRange = (50 - difference)...(50 + difference)
        let percentFalse = Double(falseCount) / Double(testCount) * 100
        XCTAssertTrue(percentRange ~= percentFalse, "One happens more often than the other.")
    }

    let min = Character(UnicodeScalar(0))
    let max = Character(UnicodeScalar(UInt8.max))

    var range: ClosedRange<Character> { return min...max }

    func testRandomCharacter() {
        let sameCount = (0...testCount).reduce(0) { count, _ in
            let r1 = Character.random(within: self.range)
            let r2 = Character.random(within: self.range)
            return count + (r1 == r2 ? 1 : 0)
        }
        XCTAssertFalse(sameCount > testCount / 100, "Too many equal random characters")
    }

    func testRandomString() {
        let sameCount = (0...(testCount/2)).reduce(0) { count, _ in
            let r1 = String.random(ofLength: 10, within: range)
            let r2 = String.random(ofLength: 10, within: range)
            return count + (r1 == r2 ? 1 : 0)
        }
        XCTAssertFalse(sameCount > 1, "Too many equal random strings")
    }

    func testRandomFromArrayTime() {
        let arr = Array(0 ..< 10000)
        self.measure {
            XCTAssertNotNil(arr.random)
        }
    }

    func testRandomFromSetTime() {
        let set = Set(0 ..< 10000)
        self.measure {
            XCTAssertNotNil(set.random)
        }
    }

    func testRandomFromDictTime() {
        let dict: [Int : Int] = RandomKitTests.randomDictionaryOfCount(10000)

        NSLog("done with making dict")
        self.measure {
            XCTAssertNotNil(dict.random)
        }
    }

    func testRandomFromCollectionType() {
        let arr = ["A", "B", "C", "D", "E", "F", "H", "I"]
        let dict = ["k1" : "v1", "k2" : "v2", "k3" : "v3"]
        for _ in 0...testCount {
            XCTAssertNotNil(arr.random, "Random element in non-empty array is nil")
            XCTAssertNotNil(dict.random, "Random element in non-empty dictionary is nil")
        }
    }

    func testArrayShuffleTime() {
        let a1: [Int] = (0 ..< 10000).reduce([]) { $0 + [$1] }
        var a2: [Int] = []
        self.measure {
            a2 = a1.shuffled()
        }
        XCTAssertNotEqual(a1, a2)
    }

    func testDictionaryShuffleTime() {
        let d1: [Int : Int] = RandomKitTests.randomDictionaryOfCount(1000)
        var d2: [Int : Int] = [:]
        self.measure {
            d2 = d1.shuffled()
        }
        XCTAssertNotEqual(d1, d2)
    }

    func testStringShuffleTime() {
        let str1 = (0 ..< 10000).reduce("") { str, _ in
            str + String(Int.random(within: 0...9))
        }
        var str2 = ""
        self.measure {
            str2 = str1.shuffled()
        }
        XCTAssertNotEqual(str1, str2)
    }

    func testRandomGeneratorAndSequence() {
        do {
            let iter = Int.randomIterator()
            for _ in 0...10 {
                XCTAssertNotNil(iter.next())
            }
        }
        do {
            let c = 10
            var i = 0
            var a = [Int]()
            for v in Int.randomSequence() {
                defer { i += 1 }

                if i >= c { break }
                a.append(v)
            }
            XCTAssertEqual(a.count, c)
        }
        do {
            var i = 0
            let c = 10
            let iter = Int.randomIterator(maxCount: c)
            while let _ = iter.next() {
                i += 1
            }
            XCTAssertEqual(i, c)
        }
        do {
            let c = 10
            let s = Int.randomSequence(maxCount: c)
            XCTAssertEqual(Array(s).count, c)
        }
    }

    func testRandomArray() {
        let array: [Int] = Array(randomCount: 10)
        XCTAssertEqual(array.count, 10)
    }

    func testRandomSet() {
        let set = Set<Int>(randomCount: 10)
        XCTAssertEqual(set.count, 10)
    }

    func testRandomDictionary() {
        let dict: [Int : String] = Dictionary(randomCount: 10)
        XCTAssertEqual(dict.count, 10)
    }

    func testRandomArraySlice() {
        let count = 10
        let array: [Int] = Array(randomCount: count)
        let sliceCount = count / 2

        var result = array.randomSlice(count: sliceCount)
        XCTAssertEqual(result.count, sliceCount)
        let simpleSlice = Array(array[0..<sliceCount])
        XCTAssertNotEqual(result, simpleSlice)

        result = array.randomSlice(count: count) // all
        XCTAssertEqual(result.count, count)

        result = array.randomSlice(count: count * 2) // too much
        XCTAssertEqual(result.count, count)

        result = array.randomSlice(count: 0) // nothing
        XCTAssertEqual(result.count, 0)

        let weightsArray: [[Double]] = [
            Array(randomCount: count),
            Array(randomCount: count, within: 0...100)
        ]

        for weights in weightsArray {
            result = array.randomSlice(count: count, weights: weights) // all
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: sliceCount, weights: weights)
            XCTAssertEqual(result.count, sliceCount)
            //let simpleSlice = Array(array[0..<sliceCount])
            // XCTAssertNotEqual(result, simpleSlice) // cannot be sure, depends and weights

            result = array.randomSlice(count: count * 2, weights: weights) // too much
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: count * 2, weights: Array(randomCount: count / 2)) // partial weights
            XCTAssertEqual(result.count, count)

            result = array.randomSlice(count: 0, weights: weights) // nothing
            XCTAssertEqual(result.count, 0)
        }
    }

    private static func randomDictionaryOfCount(_ count: Int) -> [Int : Int] {
        return (0 ..< count).reduce(Dictionary(minimumCapacity: count)) { (dict, num) in
            var mutableDict = dict

            mutableDict[num] = num
            return mutableDict
        }
    }
}
