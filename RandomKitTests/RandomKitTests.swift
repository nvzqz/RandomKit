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

    func testRandomDouble() {
        let min = -1.5
        let max =  0.5
        for _ in 0...testCount {
            let r = Double.random(min...max)
            XCTAssertTrue(r >= min && r <= max, "Random `Double` is out of bounds.")
        }
    }

    func testRandomFloat() {
        let min: Float = -1.5
        let max: Float =  0.5
        for _ in 0...testCount {
            let r = Float.random(min...max)
            XCTAssertTrue(r >= min && r <= max, "Random `Float` is out of bounds.")
        }
    }

    func testRandomBool() {
        let falseCount = (0...testCount).reduce(0) { count, _ in
            Bool.random() ? count : count + 1
        }
        let percentFalse = Double(falseCount)/Double(testCount) * 100
        XCTAssertTrue(percentFalse > 49.75 && percentFalse < 50.75, "One happens more often than the other.")
    }

    let min = Character(UnicodeScalar(0))
    let max = Character(UnicodeScalar(UInt8.max))

    var interval: ClosedInterval<Character> { return min...max }

    func testRandomCharacter() {
        let sameCount = (0...testCount).reduce(0) { count, _ in
            let r1 = Character.random(self.interval)
            let r2 = Character.random(self.interval)
            return count + (r1 == r2 ? 1 : 0)
        }
        XCTAssertFalse(sameCount > testCount / 100, "Too many equal random characters")
    }

    func testRandomString() {
        let sameCount = (0...(testCount/2)).reduce(0) { count, _ in
            let r1 = String.random(10, interval)
            let r2 = String.random(10, interval)
            return count + (r1 == r2 ? 1 : 0)
        }
        XCTAssertFalse(sameCount > 1, "Too many equal random strings")
    }

    func testRandomFromArrayTime() {
        let arr = Array(0 ..< 10000)
        self.measureBlock {
            XCTAssertNotNil(arr.random)
        }
    }

    func testRandomFromSetTime() {
        let set = Set(0 ..< 10000)
        self.measureBlock {
            XCTAssertNotNil(set.random)
        }
    }

    func testRandomFromDictTime() {
        let count = 10000
        let dict: [Int : Int] = (0 ..< count).reduce(Dictionary(minimumCapacity: count)) { (var dict, num) in
            dict[num] = num
            return dict
        }
        NSLog("done with making dict")
        self.measureBlock {
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
        let a1 = (0 ..< 10000).reduce([]) { $0 + [$1] }
        var a2: [Int] = []
        self.measureBlock {
            a2 = a1.shuffle()
        }
        XCTAssertNotEqual(a1, a2)
    }

    func testDictionaryShuffleTime() {
        let d1: [Int : Int] = (0 ..< 1000).reduce(Dictionary(minimumCapacity: 1000)) { (var dict, n) in
            dict[n] = n
            return dict
        }
        var d2: [Int : Int] = [:]
        self.measureBlock {
            d2 = d1.shuffle()
        }
        XCTAssertNotEqual(d1, d2)
    }

    func testStringShuffleTime() {
        let str1 = (0 ..< 10000).reduce("") { str, _ in
            str + String(Int.random(0...9))
        }
        var str2 = ""
        self.measureBlock {
            str2 = str1.shuffle()
        }
        XCTAssertNotEqual(str1, str2)
    }
    
    func testRandomGeneratorAndSequence() {
        do {
            let g = Int.randomGenerator()
            for _ in 0...10 {
                XCTAssertNotNil(g.next())
            }
        }
        do {
            let c = 10
            var i = 0
            var a = [Int]()
            for v in Int.randomSequence() {
                if i++ >= c { break }
                a.append(v)
            }
            XCTAssertEqual(a.count, c)
        }
        do {
            var i = 0
            let c = 10
            let g = Int.randomGenerator(maxCount: c)
            while let _ = g.next() {
                i++
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

}
