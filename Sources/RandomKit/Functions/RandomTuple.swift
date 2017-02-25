//
//  RandomTuple.swift
//  RandomKit
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

/// Returns a random tuple by generating random values for the elements of the result using `randomGenerator`.
public func randomTuple<A: Random,
                        B: Random,
                        R: RandomGenerator>(using randomGenerator: inout R) -> (A, B) {
    return (.random(using: &randomGenerator),
            .random(using: &randomGenerator))
}

/// Returns a random tuple by generating random values for the elements of the result using `randomGenerator`.
public func randomTuple<A: Random,
                        B: Random,
                        C: Random,
                        R: RandomGenerator>(using randomGenerator: inout R) -> (A, B, C) {
    return (.random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator))
}

/// Returns a random tuple by generating random values for the elements of the result using `randomGenerator`.
public func randomTuple<A: Random,
                        B: Random,
                        C: Random,
                        D: Random,
                        R: RandomGenerator>(using randomGenerator: inout R) -> (A, B, C, D) {
    return (.random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator))
}

/// Returns a random tuple by generating random values for the elements of the result using `randomGenerator`.
public func randomTuple<A: Random,
                        B: Random,
                        C: Random,
                        D: Random,
                        E: Random,
                        R: RandomGenerator>(using randomGenerator: inout R) -> (A, B, C, D, E) {
    return (.random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator))
}

/// Returns a random tuple by generating random values for the elements of the result using `randomGenerator`.
public func randomTuple<A: Random,
                        B: Random,
                        C: Random,
                        D: Random,
                        E: Random,
                        F: Random,
                        R: RandomGenerator>(using randomGenerator: inout R) -> (A, B, C, D, E, F) {
    return (.random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator),
            .random(using: &randomGenerator))
}
