//
//  XoroshiroTests.swift
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

private let seeded = Xoroshiro(seed: (0xCAFEBABE, 0xDEADBEEF))

private let initialValues: [UInt64] = [
    0x00000001A9AC79AD, 0xA4304A24D5223B0D, 0xDE42A620748FEA5D, 0xB01B3C241344C99F,
    0xC18AB4F4E0478824, 0xC436CCE98D461624, 0x0B0DD23E077302D6, 0xF748D10BEEDEB1DB,
    0x992D2C12F71F5763, 0x8C6EA4B413685AFD, 0x19761EDEAC1F40EB, 0xEF33591D055F5219,
    0xAD74E86B017456D2, 0x7135F72BD7213627, 0x12E59B42568F8778, 0x2E221CA48B41FA5C,
    0xC689AB8F3433B5F2, 0x6D42F611FBC82004, 0xE687E8CD1AEFBCCA, 0xC568E64AA44A776E,
    0x0EC58A855635679E, 0xFD7331C3E8685111, 0x981CB22792B75DEA, 0x493056E8104E315B,
    0xF86AAB6BC70CCDFC, 0xE00322219B3B6D86, 0xD58D4F14A86232D3, 0x7F088610C7DC4A3B,
    0x62A73B5BB4960287, 0x62015EE3CB9AEBC8, 0xBBDECC4A746B9195, 0xEA470BEBEB7B5631
]

private let jumpValues: [UInt64] = [
    0x3AF10035D5FC2E18, 0x1360B353D9255303, 0x050ED3FDD1CCF08F, 0x0EA5541FE327DA68,
    0x438FEC4BBDADF3C0, 0x0126EBD568F23FC7, 0x8C2A7B5F7B614695, 0x80E3B1500BD8A70E,
    0xFC00A1F1AFF67F9C, 0x4AB2B9C3C46A3E8C, 0xE35C2A8B4FCD20A2, 0x0C1298D48F7F0B72,
    0x8951D232379E01AF, 0x5902E746E40D0FA1, 0x5469CD8FF2FD80C8, 0xE1DCCC9BFA800B8B,
    0xB04957FFF1746280, 0x21905B2879507AAC, 0xE4182DBFC1B8E7A9, 0xFB8D817A3592BA47,
    0x7D546E9F9FA2FDD8, 0x1E89D37183A67E21, 0x160B03166876B5AC, 0x22D4C916868A5091,
    0x581DB41C52A89FAF, 0x3A66768B4656AF5B, 0x4C28E3B0B3C8DD76, 0xC99C2688421A1D6D,
    0x8AF2782C9DF5AFDD, 0x42D0D803ABB9F6FA, 0x853F8D87C336E774, 0x9EE90EFA7541E134
]

class XoroshiroTests: XCTestCase, Tester {

    typealias Gen = Xoroshiro

    static let allTests = tests + [("testValues", testValues),
                                   ("testJump", testJump)]

    func testValues() {
        var gen = seeded
        XCTAssertEqual([UInt64](randomCount: 32, using: &gen), initialValues)
    }

    func testJump() {
        var gen = seeded
        gen.jump()
        XCTAssertEqual([UInt64](randomCount: 32, using: &gen), jumpValues)
    }

    func testRandomInt() {
        testRandomInt(count: defaultTestCount)
    }

    func testRandomOpen() {
        testRandomOpen(count: defaultTestCount)
    }

    func testRandomClosed() {
        testRandomClosed(count: defaultTestCount)
    }

    func testRandomDouble() {
        testRandomDouble(count: defaultTestCount)
    }

    func testRandomFloat() {
        testRandomFloat(count: defaultTestCount)
    }

    func testRandomBool() {
        testRandomBool(count: defaultTestCount)
    }

    func testRandomArraySlice() {
        testRandomArraySliceImpl()
    }

}
