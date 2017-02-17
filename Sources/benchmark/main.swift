//
//  main.swift
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

func contains(_ arg: String) -> Bool {
    let arg = arg.lowercased()
    return CommandLine.arguments.contains { $0.lowercased() == arg }
}

func argument(after arg: String) -> String? {
    let arg = arg.lowercased()
    if let index = CommandLine.arguments.indices.first(where: { CommandLine.arguments[$0].lowercased() == arg }) {
        return CommandLine.arguments[safe: index + 1]
    } else {
        return nil
    }
}

func int(after arg: String) -> Int? {
    return argument(after: arg).flatMap { Int($0) }
}

func hasArgs() -> Bool {
    let args = CommandLine.arguments
    return args.count > 1 && args.suffix(from: 1).contains(where: { $0.lowercased() != "--no-color" })
}

let styleOutput = !contains("--no-color")

if !hasArgs() || contains("--help") || contains("-h") {
    printHelpAndExit()
}

let benchmarkAll           = contains("--all") || contains("-a")
let benchmarkAllGenerators = benchmarkAll || contains("--all-generators")
let benchmarkAllIntegers   = benchmarkAll || contains("--all-integers")
let benchmarkAllProtocols  = benchmarkAll || contains("--all-protocols")

let benchmarkRandom                  = benchmarkAllProtocols || contains("Random")
let benchmarkRandomToValue           = benchmarkAllProtocols || contains("RandomToValue")
let benchmarkRandomThroughValue      = benchmarkAllProtocols || contains("RandomThroughValue")
let benchmarkRandomWithinRange       = benchmarkAllProtocols || contains("RandomWithinRange")
let benchmarkRandomWithinClosedRange = benchmarkAllProtocols || contains("RandomWithinClosedRange")

let benchmarkShuffle = contains("--shuffle")
let benchmarkShuffleCount = int(after: "--shuffle") ?? 100
let benchmarkShuffleUnique = contains("--shuffle-unique")
let benchmarkShuffleUniqueCount = int(after: "--shuffle-unique") ?? 100

let benchmarkRandoms = contains("--randoms")

let benchmarkRandomSet      = contains("--set")
let benchmarkRandomSetCount = int(after: "--set") ?? 100

let benchmarkRandomArray            = contains("--array")
let benchmarkRandomArrayCount       = int(after: "--array")
let benchmarkSafeRandomArray        = benchmarkRandomArray         || contains("--array-safe")
let benchmarkSafeRandomArrayCount   = int(after: "--array-safe")   ?? benchmarkRandomArrayCount ?? 100
let benchmarkUnsafeRandomArray      = benchmarkRandomArray         || contains("--array-unsafe")
let benchmarkUnsafeRandomArrayCount = int(after: "--array-unsafe") ?? benchmarkRandomArrayCount ?? 100

func arc4RandomIsAvailable() -> Bool {
    let available = ARC4Random.isAvailable
    if !available {
        print(style("The arc4random generator is unavailable", with: [.bold, .red]))
    }
    return available
}

let count = int(after: "--count") ?? int(after: "-c") ?? 10_000_000

func bench(_ generator: String) -> Bool {
    return benchmarkAllGenerators || contains(generator)
}

if bench("--xoroshiro") {
    runBenchmarks(using: &Xoroshiro.default)
}

if bench("--xorshift") {
    runBenchmarks(using: &Xorshift.default)
}

if bench("--xorshift-star") {
    runBenchmarks(using: &XorshiftStar.default)
}

if bench("--mersenne-twister") {
    runBenchmarks(using: &MersenneTwister.default)
}

if bench("--arc4random") && arc4RandomIsAvailable() {
    runBenchmarks(using: &ARC4Random.default)
}

if bench("--dev") {
    runBenchmarks(using: &DeviceRandom.default)
}
