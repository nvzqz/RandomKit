//
//  main.swift
//  RandomKit Benchmark
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
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

func contains(_ s: String) -> Bool {
    return CommandLine.arguments.contains(s)
}

let styleOutput = !contains("--no-color")

let benchmarkAll           = contains("--all")
let benchmarkAllGenerators = benchmarkAll || contains("--all-generators")
let benchmarkAllIntegers   = benchmarkAll || contains("--all-integers")
let benchmarkAllProtocols  = benchmarkAll || contains("--all-protocols")

let benchmarkRandom             = benchmarkAllProtocols || contains("Random")
let benchmarkRandomToValue      = benchmarkAllProtocols || contains("RandomToValue")
let benchmarkRandomThroughValue = benchmarkAllProtocols || contains("RandomThroughValue")

let count: Int = {
    let args = CommandLine.arguments
    if let index = args.index(of: "--count"), let count = args[safe: index + 1].flatMap({ Int($0) }) {
        return count
    } else {
        return 10_000_000
    }
}()

let generators: [RandomGenerator]
if benchmarkAllGenerators {
    generators = [
        .xoroshiro(threadSafe: false),
        .xoroshiro(threadSafe: true),
        .arc4Random,
        .dev(.urandom)
    ]
} else if contains("--xoroshiro") {
    generators = [
        .xoroshiro(threadSafe: false),
        .xoroshiro(threadSafe: true)
    ]
} else if contains("--xoroshiro-unsafe") {
    generators = [
        .xoroshiro(threadSafe: false)
    ]
} else if contains("--xoroshiro-safe") {
    generators = [
        .xoroshiro(threadSafe: true)
    ]
} else if contains("--arc4random") {
    generators = [
        .arc4Random
    ]
} else if contains("--dev") || contains("--dev-urandom") {
    generators = [
        .dev(.urandom)
    ]
} else if contains("--dev-random") {
    generators = [
        .dev(.random)
    ]
} else {
    generators = [
        .xoroshiro(threadSafe: false),
        .xoroshiro(threadSafe: true),
        .arc4Random
    ]
}

if benchmarkRandom {
    benchmarkRandom(for: Int.self)
    if benchmarkAllIntegers {
        benchmarkRandom(for: Int64.self)
        benchmarkRandom(for: Int32.self)
        benchmarkRandom(for: Int16.self)
        benchmarkRandom(for: Int8.self)
    }
    benchmarkRandom(for: UInt.self)
    if benchmarkAllIntegers {
        benchmarkRandom(for: UInt64.self)
        benchmarkRandom(for: UInt32.self)
        benchmarkRandom(for: UInt16.self)
        benchmarkRandom(for: UInt8.self)
    }
}

if benchmarkRandomToValue {
    benchmarkRandomToValue(with: Int.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomToValue(with: Int64.maxAdjusted)
        benchmarkRandomToValue(with: Int32.maxAdjusted)
        benchmarkRandomToValue(with: Int16.maxAdjusted)
        benchmarkRandomToValue(with: Int8.maxAdjusted)
    }
    benchmarkRandomToValue(with: UInt.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomToValue(with: UInt64.maxAdjusted)
        benchmarkRandomToValue(with: UInt32.maxAdjusted)
        benchmarkRandomToValue(with: UInt16.maxAdjusted)
        benchmarkRandomToValue(with: UInt8.maxAdjusted)
    }
}

if benchmarkRandomThroughValue {
    benchmarkRandomThroughValue(with: Int.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomThroughValue(with: Int64.maxAdjusted)
        benchmarkRandomThroughValue(with: Int32.maxAdjusted)
        benchmarkRandomThroughValue(with: Int16.maxAdjusted)
        benchmarkRandomThroughValue(with: Int8.maxAdjusted)
    }
    benchmarkRandomThroughValue(with: UInt.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomThroughValue(with: UInt64.maxAdjusted)
        benchmarkRandomThroughValue(with: UInt32.maxAdjusted)
        benchmarkRandomThroughValue(with: UInt16.maxAdjusted)
        benchmarkRandomThroughValue(with: UInt8.maxAdjusted)
    }
}
