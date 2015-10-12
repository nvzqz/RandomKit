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

    func testRandomDictionaryValue() {
        let emptyDict: [String : String] = [:]
        XCTAssertNil(emptyDict.random(), "Random element in empty dictionary is not nil???")
        let dict = ["k1" : "v1", "k2" : "v2", "k3" : "v3"]
        for _ in 1...dict.count {
            XCTAssertNotNil(dict.random(), "Random element in non-empty dictionary is nil")
        }
    }

}
