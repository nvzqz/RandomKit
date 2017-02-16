//
//  Benchmark.swift
//  RandomKit Benchmark
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

import RandomKit
import Foundation

func time(count: Int, closure: () -> ()) -> TimeInterval {
    let start = Date()
    for _ in 0 ..< count {
        closure()
    }
    return Date().timeIntervalSince(start)
}

func benchmark(count: Int, closure: () -> ()) {
    let total = time(count: count, closure: closure)
    let indiv = total / Double(count)
    print("\(count) in " + style(total, with: [.blue]) + " seconds")
    print("1 in "        + style(indiv, with: [.blue]) + " seconds")
}

func benchmarkRandom<T: Random, R: RandomGenerator>(for type: T.Type,
                     count: Int = count,
                     using randomGenerator: inout R) {
    print("Generating " + style(count: count) + " randoms for " + style(type) + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = T.random(using: &randomGenerator)
    }
    print("")
}

func benchmarkRandomToValue<T: RandomToValue, R: RandomGenerator>(with value: T,
                            count: Int = count,
                            using randomGenerator: inout R) {
    let styledValue = style(value)
    let styledType  = style(T.self)
    print("Generating " + style(count: count) + " randoms to " + styledValue + " for " + styledType + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = T.random(to: value, using: &randomGenerator)
    }
    print("")
}

func benchmarkRandomThroughValue<T: RandomThroughValue, R: RandomGenerator>(with value: T,
                                 count: Int = count,
                                 using randomGenerator: inout R) {
    let styledValue = style(value)
    let styledType  = style(T.self)
    print("Generating " + style(count: count) + " randoms through " + styledValue + " for " + styledType + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = T.random(through: value, using: &randomGenerator)
    }
    print("")
}

func benchmarkRandomWithinRange<T: RandomWithinRange, R: RandomGenerator>(with range: Range<T>,
                                count: Int = count,
                                using randomGenerator: inout R) {
    let styledRange = style(range)
    let styledType  = style(T.self)
    print("Generating " + style(count: count) + " randoms within " + styledRange + " for " + styledType + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = T.random(within: range, using: &randomGenerator)
    }
    print("")
}

func benchmarkRandomWithinClosedRange<T: RandomWithinClosedRange, R: RandomGenerator>(with closedRange: ClosedRange<T>,
                                      count: Int = count,
                                      using randomGenerator: inout R) {
    let styledRange = style(closedRange)
    let styledType  = style(T.self)
    print("Generating " + style(count: count) + " randoms within " + styledRange + " for " + styledType + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = T.random(within: closedRange, using: &randomGenerator)
    }
    print("")
}

func benchmarkRandoms<T: Random, R: RandomGenerator>(for type: T.Type, count: Int = count, using randomGenerator: inout R) {
    print("Generating " + style(count: count) + " limited randoms for " + style(type) + " using " + style(randomGenerator))
    benchmark(count: 1) {
        var randoms = type.randoms(limitedBy: count, using: &randomGenerator)
        while let _ = randoms.next() {}
    }
}

func benchmarkRandomSet<T: Random & Hashable, R: RandomGenerator>(for type: T.Type, randomCount: Int,
                        count: Int = count,
                        using randomGenerator: inout R) {
    print("Generating " + style(count: count) + " random sets for " + style(type) + " of " + style(randomCount) + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = Set<T>(randomCount: randomCount, using: &randomGenerator)
    }
    print("")
}

func benchmarkSafeRandomArray<T: Random, R: RandomGenerator>(for type: T.Type, randomCount: Int,
                              count: Int = count,
                              using randomGenerator: inout R) {
    print("Generating " + style(count: count) + " random arrays for " + style(type) + " of " + style(randomCount) + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = [T](randomCount: randomCount, using: &randomGenerator)
    }
    print("")
}

func benchmarkUnsafeRandomArray<T: UnsafeRandom, R: RandomGenerator>(for type: T.Type,
                                randomCount: Int,
                                count: Int = count,
                                using randomGenerator: inout R) {
    print("Generating " + style(count: count) + " unsafe random arrays for " + style(type) + " of " + style(randomCount) + " using " + style(randomGenerator))
    benchmark(count: count) {
        let _ = [T](unsafeRandomCount: randomCount, using: &randomGenerator)
    }
    print("")
}

func runBenchmarks<R: RandomGenerator>(using randomGenerator: inout R) {
    if benchmarkRandom {
        benchmarkRandom(for: Int.self, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandom(for: Int64.self, using: &randomGenerator)
            benchmarkRandom(for: Int32.self, using: &randomGenerator)
            benchmarkRandom(for: Int16.self, using: &randomGenerator)
            benchmarkRandom(for: Int8.self, using: &randomGenerator)
        }
        benchmarkRandom(for: UInt.self, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandom(for: UInt64.self, using: &randomGenerator)
            benchmarkRandom(for: UInt32.self, using: &randomGenerator)
            benchmarkRandom(for: UInt16.self, using: &randomGenerator)
            benchmarkRandom(for: UInt8.self, using: &randomGenerator)
        }
    }

    if benchmarkRandomToValue {
        benchmarkRandomToValue(with: Int.maxAdjusted, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomToValue(with: Int64.maxAdjusted, using: &randomGenerator)
            benchmarkRandomToValue(with: Int32.maxAdjusted, using: &randomGenerator)
            benchmarkRandomToValue(with: Int16.maxAdjusted, using: &randomGenerator)
            benchmarkRandomToValue(with: Int8.maxAdjusted, using: &randomGenerator)
        }
        benchmarkRandomToValue(with: UInt.maxAdjusted, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomToValue(with: UInt64.maxAdjusted, using: &randomGenerator)
            benchmarkRandomToValue(with: UInt32.maxAdjusted, using: &randomGenerator)
            benchmarkRandomToValue(with: UInt16.maxAdjusted, using: &randomGenerator)
            benchmarkRandomToValue(with: UInt8.maxAdjusted, using: &randomGenerator)
        }
    }

    if benchmarkRandomThroughValue {
        benchmarkRandomThroughValue(with: Int.maxAdjusted, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomThroughValue(with: Int64.maxAdjusted, using: &randomGenerator)
            benchmarkRandomThroughValue(with: Int32.maxAdjusted, using: &randomGenerator)
            benchmarkRandomThroughValue(with: Int16.maxAdjusted, using: &randomGenerator)
            benchmarkRandomThroughValue(with: Int8.maxAdjusted, using: &randomGenerator)
        }
        benchmarkRandomThroughValue(with: UInt.maxAdjusted, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomThroughValue(with: UInt64.maxAdjusted, using: &randomGenerator)
            benchmarkRandomThroughValue(with: UInt32.maxAdjusted, using: &randomGenerator)
            benchmarkRandomThroughValue(with: UInt16.maxAdjusted, using: &randomGenerator)
            benchmarkRandomThroughValue(with: UInt8.maxAdjusted, using: &randomGenerator)
        }
    }

    if benchmarkRandomWithinRange {
        benchmarkRandomWithinRange(with: Int.minMaxRange, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomWithinRange(with: Int64.minMaxRange, using: &randomGenerator)
            benchmarkRandomWithinRange(with: Int32.minMaxRange, using: &randomGenerator)
            benchmarkRandomWithinRange(with: Int16.minMaxRange, using: &randomGenerator)
            benchmarkRandomWithinRange(with: Int8.minMaxRange, using: &randomGenerator)
        }
        benchmarkRandomWithinRange(with: UInt.minMaxRange, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomWithinRange(with: UInt64.minMaxRange, using: &randomGenerator)
            benchmarkRandomWithinRange(with: UInt32.minMaxRange, using: &randomGenerator)
            benchmarkRandomWithinRange(with: UInt16.minMaxRange, using: &randomGenerator)
            benchmarkRandomWithinRange(with: UInt8.minMaxRange, using: &randomGenerator)
        }
    }

    if benchmarkRandomWithinClosedRange {
        benchmarkRandomWithinClosedRange(with: Int.minMaxClosedRange, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomWithinClosedRange(with: Int64.minMaxClosedRange, using: &randomGenerator)
            benchmarkRandomWithinClosedRange(with: Int32.minMaxClosedRange, using: &randomGenerator)
            benchmarkRandomWithinClosedRange(with: Int16.minMaxClosedRange, using: &randomGenerator)
            benchmarkRandomWithinClosedRange(with: Int8.minMaxClosedRange, using: &randomGenerator)
        }
        benchmarkRandomWithinClosedRange(with: UInt.minMaxClosedRange, using: &randomGenerator)
        if benchmarkAllIntegers {
            benchmarkRandomWithinClosedRange(with: UInt64.minMaxClosedRange, using: &randomGenerator)
            benchmarkRandomWithinClosedRange(with: UInt32.minMaxClosedRange, using: &randomGenerator)
            benchmarkRandomWithinClosedRange(with: UInt16.minMaxClosedRange, using: &randomGenerator)
            benchmarkRandomWithinClosedRange(with: UInt8.minMaxClosedRange, using: &randomGenerator)
        }
    }

    if benchmarkRandoms {
        benchmarkRandoms(for: Int.self, using: &randomGenerator)
    }

    if benchmarkRandomSet {
        benchmarkRandomSet(for: Int.self, randomCount: benchmarkRandomSetCount, using: &randomGenerator)
    }

    if benchmarkSafeRandomArray {
        benchmarkSafeRandomArray(for: Int.self, randomCount: benchmarkSafeRandomArrayCount, using: &randomGenerator)
    }

    if benchmarkUnsafeRandomArray {
        benchmarkUnsafeRandomArray(for: Int.self, randomCount: benchmarkUnsafeRandomArrayCount, using: &randomGenerator)
    }
}
