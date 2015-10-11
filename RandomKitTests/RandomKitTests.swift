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

    let min = Character(UnicodeScalar(0))
    let max = Character(UnicodeScalar(UInt8.max))

    var interval: ClosedInterval<Character> { return min...max }

    func testRandomCharacter() {
        let r1 = Character.random(self.interval)
        let r2 = Character.random(self.interval)
        XCTAssertNotEqual(r1, r2, "Random characters are equal")
    }

}
