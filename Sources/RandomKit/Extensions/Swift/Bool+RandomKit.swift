//
//  Bool+RandomKit.swift
//  RandomKit
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

import Foundation

extension Bool: Random {

    /// Generates a random `Bool`.
    public static func random(using randomGenerator: RandomGenerator) -> Bool {
        return UInt.random(using: randomGenerator) % 2 == 0
    }

}

extension Bool {

    /// Generate a Bool random value from bernouilli distribution.
    /// https://en.wikipedia.org/wiki/Bernoulli_distribution
    /// - parameter probability: probability p parameter of bernouilli distribution. Must be > 0 and < 1.
    public static func randomBernoulli<P: BernoulliProbability>(probability: P, using randomGenerator: RandomGenerator = .default) -> Bool {
        return P.randomProbability(using: randomGenerator) < probability
    }

}
