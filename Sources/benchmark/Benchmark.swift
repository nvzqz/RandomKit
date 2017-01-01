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

func benchmarkRandom<T: Random>(for type: T.Type, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        print("Generating " + style(count: count) + " randoms for " + style(type) + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = T.random(using: randomGenerator)
        }
        print("")
    }
}

func benchmarkRandomToValue<T: RandomToValue>(with value: T, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        let styledValue = style(value)
        let styledType  = style(T.self)
        print("Generating " + style(count: count) + " randoms to " + styledValue + " for " + styledType + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = T.random(to: value, using: randomGenerator)
        }
        print("")
    }
}

func benchmarkRandomThroughValue<T: RandomThroughValue>(with value: T, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        let styledValue = style(value)
        let styledType  = style(T.self)
        print("Generating " + style(count: count) + " randoms through " + styledValue + " for " + styledType + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = T.random(through: value, using: randomGenerator)
        }
        print("")
    }
}

func benchmarkRandomWithinRange<T: RandomWithinRange>(with range: Range<T>, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        let styledRange = style(range)
        let styledType  = style(T.self)
        print("Generating " + style(count: count) + " randoms within " + styledRange + " for " + styledType + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = T.random(within: range, using: randomGenerator)
        }
        print("")
    }
}

func benchmarkRandomWithinClosedRange<T: RandomWithinClosedRange>(with closedRange: ClosedRange<T>, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        let styledRange = style(closedRange)
        let styledType  = style(T.self)
        print("Generating " + style(count: count) + " randoms within " + styledRange + " for " + styledType + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = T.random(within: closedRange, using: randomGenerator)
        }
        print("")
    }
}

func benchmarkSafeRandomArray<T: Random>(for type: T.Type, randomCount: Int, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        print("Generating " + style(count: count) + " random arrays for " + style(type) + " of " + style(randomCount) + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = [T](randomCount: randomCount, using: randomGenerator)
        }
        print("")
    }
}

func benchmarkUnsafeRandomArray<T: UnsafeRandom>(for type: T.Type, randomCount: Int, count: Int = count, using generators: [RandomGenerator] = generators) {
    for randomGenerator in generators {
        print("Generating " + style(count: count) + " unsafe random arrays for " + style(type) + " of " + style(randomCount) + " using " + style(randomGenerator))
        benchmark(count: count) {
            let _ = [T](unsafeRandomCount: randomCount, using: randomGenerator)
        }
        print("")
    }
}
