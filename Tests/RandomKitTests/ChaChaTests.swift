//
//  ChaChaTests.swift
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

class ChaChaTests: XCTestCase {

    static let allTests = [("testReseed", testReseed),
                           ("testValues", testValues)]

    func testReseed() {
        let seed = [UInt32](randomCount: 8, using: &DeviceRandom.default)
        var gen = ChaCha(seed: seed)
        let arr1 = [UInt8](randomCount: 100, using: &gen)
        gen.reseed(with: seed)
        let arr2 = [UInt8](randomCount: 100, using: &gen)
        XCTAssertEqual(arr1, arr2)
    }

    func testValues() {
        var rng = ChaCha(seed: repeatElement(0, count: 8))

        XCTAssertEqual([UInt32](randomCount: 32, using: &rng),
                       [0xade0b876, 0x903df1a0, 0xe56a5d40, 0x28bd8653,
                        0xb819d2bd, 0x1aed8da0, 0xccef36a8, 0xc70d778b,
                        0x7c5941da, 0x8d485751, 0x3fe02477, 0x374ad8b8,
                        0xf4b8436a, 0x1ca11815, 0x69b687c3, 0x8665eeb2,
                        0xbee7079f, 0x7a385155, 0x7c97ba98, 0x0d082d73,
                        0xa0290fcb, 0x6965e348, 0x3e53c612, 0xed7aee32,
                        0x7621b729, 0x434ee69c, 0xb03371d5, 0xd539d874,
                        0x281fed31, 0x45fb0a51, 0x1f0ae1ac, 0x6f4d794b])

        rng.reseed(with: 0...7)
        let num = 16
        var arr = [UInt32]()
        arr.reserveCapacity(num)

        for _ in 0 ..< num {
            arr.append(rng.random32())
            for _ in 0 ..< num {
                _ = rng.random32()
            }
        }

        XCTAssertEqual(arr,
                       [0xf225c81a, 0x6ab1be57, 0x04d42951, 0x70858036,
                        0x49884684, 0x64efec72, 0x4be2d186, 0x3615b384,
                        0x11cfa18e, 0xd3c50049, 0x75c775f6, 0x434c6530,
                        0x2c5bad8f, 0x898881dc, 0x5f1c86d9, 0xc1f8e7f4])
    }

}
