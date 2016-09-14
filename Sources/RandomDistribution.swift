//
//  RandomDistribution.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
//  Copyright (c) 2015-2016 Marchand Eric
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
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

// Type of random distribution.
public enum RandomDistribution<T: RandomDistribuableType> {

    // Pareto distribution: https://en.wikipedia.org/wiki/Pareto_distribution
    case pareto(scale: T, shape: T)
    // Weibulldistribution: https://en.wikipedia.org/wiki/Weibull_distribution
    case weibull(scale: T, shape: T)
    // Gaussian or normal distribution: https://en.wikipedia.org/wiki/Normal_distribution
    case gaussian(mean: T, standardDeviation: T)
    // Log normal distribution: https://en.wikipedia.org/wiki/Log-normal_distribution
    case logNormal(mean: T, standardDeviation: T)
    // Exponentiel distribution: https://en.wikipedia.org/wiki/Exponential_distribution
    case exponential(rate: T)
    // Gamma distribution: https://en.wikipedia.org/wiki/Gamma_distribution
    case gamma(rate: T, shape: T)
    // Beta disctribution: https://en.wikipedia.org/wiki/Beta_distribution
    case beta(shape1: T, shape2: T)
    // Uniform distribution: https://en.wikipedia.org/wiki/Uniform_distribution
    case uniform(min: T, max: T)
    
    // Gaussian distribution with 0 as mean and 1 as standard deviation
    public static var gaussianDefault: RandomDistribution<T> {
        return RandomDistribution.gaussian(mean: 0, standardDeviation: 1)
    }
    
    // Return an uniform distribution using range
    public static func uniformOn(range: ClosedRange<T>) -> RandomDistribution<T> {
        return .uniform(min: range.lowerBound, max: range.upperBound)
    }
}

/// A type that can generate a random value using specified `RandomDistribution`
public protocol RandomDistribuableType: RandomIntervalType, ExpressibleByIntegerLiteral {

    // Maths Operators (like IntegerArithmetic)
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    static func %(lhs: Self, rhs: Self) -> Self
    static prefix func -(lhs: Self) -> Self

    // Maths Functions
    func pow(_ value: Self) -> Self
    func sqrt() -> Self
    func log() -> Self
    func exp() -> Self
    
    // Cache gaussian next value
    static var nextGaussianValue: Self? {get set}
}

extension RandomDistribuableType {

    // Generate a random value from specified distribution.
    public static func random(distribution: RandomDistribution<Self>) -> Self {
        switch (distribution) {
        case .pareto(let scale, let shape):
            return randomPareto(scale: scale, shape: shape)
        case .weibull(let scale,let  shape):
            return randomPareto(scale: scale, shape: shape)
        case .gaussian(let mean, let standardDeviation):
            return randomGaussian(mean: mean, standardDeviation: standardDeviation)
        case .logNormal(let mean, let standardDeviation):
            return randomLogNormal(mean: mean, standardDeviation: standardDeviation)
        case .exponential(let rate):
            return randomExponential(rate: rate)
        case .gamma(let rate, let shape):
            return randomGamma(rate: rate, shape: shape)
        case .beta(let shape1, let shape2):
            return randomBeta(shape1: shape1, shape2: shape2)
        case .uniform(let min,let max):
            return random(min...max)
        }
    }

    // Generate a random value from Pareto distribution.
    // https://en.wikipedia.org/wiki/Pareto_distribution
    // - parameter scale: Scale parameter of Pareto distribution. Must be > 0.
    // - parameter shape: Shape parameter of Pareto distribution. Must be > 0.
    public static func randomPareto(scale: Self, shape: Self) -> Self {
        assert(shape > 0)
        assert(scale > 0)
        let u = Self.random(0...1)
        return scale * (1 - u).pow(-1 / shape)
    }
    
    // Generate a random value from Weibull distribution.
    // https://en.wikipedia.org/wiki/Weibull_distribution
    // - parameter scale: Scale parameter of Weibull distribution. Must be > 0.
    // - parameter shape: Shape parameter of Weibull distribution. Must be > 0.
    public static func randomWeibull(scale: Self, shape: Self) -> Self {
        assert(shape > 0)
        assert(scale > 0)
        let u = Self.random(0...1)
        return scale * -(1 - u).log().pow(1 / shape)
    }

    // Generate a random value from gaussian or normal distribution
    // using polar form of the Box-Muller transformatio
    // https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    // https://en.wikipedia.org/wiki/Marsaglia_polar_method
    // - parameter mean: the approximately wanted mean
    // - parameter standardDeviation: the standard deviation.
    public static func randomGaussian(mean: Self = 0, standardDeviation: Self = 1) -> Self {
        if let next =  nextGaussianValue {
             Self.nextGaussianValue = nil
            return mean + next * standardDeviation // return previously computed property
        }
        // (others methods The Ratio method[50], The ziggurat algorithm)
        var x1: Self = 0
        var x2: Self = 0
        var w: Self = 0
        repeat {
            x1 = 2 * Self.random(0...1) - 1
            x2 = 2 * Self.random(0...1) - 1
            w = x1 * x1 + x2 * x2
        } while ( w >= 1 || w == 0)
        let multiplier = (-2 * w.log()/w).sqrt()
        let y1 = x1 * multiplier
        Self.nextGaussianValue = x2 * multiplier
        return mean + y1 * standardDeviation
    }
    
    // Generate a random value from lognormal distribution.
    // https://en.wikipedia.org/wiki/Log-normal_distribution
    // - parameter mean: the approximately wanted mean
    // - parameter standardDeviation: the standard deviation.
    public static func randomLogNormal(mean: Self = 0, standardDeviation: Self = 1) -> Self {
       return randomGaussian(mean: mean, standardDeviation: standardDeviation).exp()
    }
    
    // Generate a random value from exponential distribution.
    //  https://en.wikipedia.org/wiki/Exponential_distribution
    // - parameter rate: Rate parameter of exponential distribution. Must be > 0.
    public static func randomExponential(rate: Self) -> Self {
        assert(rate > 0)
        let u = Self.random(0...1)
        return -1 / rate * u.log()
    }
    
    // Generate a random value from gamma distribution.
    // https://en.wikipedia.org/wiki/Gamma_distribution
    // - parameter rate: Rate parameter of gamma distribution. Must be > 0.
    // - parameter shape: Shape parameter of gamma distribution. Must be > 0.
    public static func randomGamma(rate: Self, shape: Self) -> Self {
        let lambda = rate / shape
        var v: Self
        var u: Self
        repeat {
            u = Self.random(0...1)
            v = Self.randomExponential(rate: lambda)
        } while (shape - 1) * (1 - lambda * v).exp() < u
        
        return v
    }

    // Generate a random value from beta distribution.
    // https://en.wikipedia.org/wiki/Beta_distribution
    // - parameter shape1: Rate parameter of beta distribution. Must be > 0.
    // - parameter shape2: Shape parameter of beta distribution. Must be > 0.
    public static func randomBeta(shape1: Self, shape2: Self) -> Self {
        let a = ((shape1 - 1) / (shape1 + shape2 - 2)).pow(shape1 - 1)
        let b = ((shape2 - 1) / (shape1 + shape2 - 2)).pow(shape2 - 1)
        let maxValue = a * b
        var u1, u2: Self
        repeat {
            u1 = Self.random(0...1)
            u2 = Self.random(0...maxValue)
        } while u2 > u1.pow(shape1 - 1) * u1.pow(shape2 - 1)
        
        return u1
    }
}

// MARK: - Iterator & Sequence
extension RandomDistribuableType {

    /// Returns a generator for random values using `distribution`.
    public static func randomIterator(distribution: RandomDistribution<Self>) -> AnyIterator<Self> {
        return AnyIterator { random(distribution: distribution) }
    }
    
    /// Returns a generator for random values using `distribution` within `maxCount`.
    public static func randomIterator(maxCount count: Int, distribution: RandomDistribution<Self>) -> AnyIterator<Self> {
        var n = 0
        return AnyIterator {
            defer { n += 1 }
            return n < count ? random(distribution: distribution) : nil
        }
    }
    
    /// Returns a sequence of infinite random values using specified distribution.
    public static func randomSequence(distribution: RandomDistribution<Self>) -> AnySequence<Self> {
        return AnySequence(randomIterator(distribution: distribution))
    }
    
    
    /// Returns a sequence of random values using specified distribution within `maxCount`.
    public static func randomSequence(maxCount count: Int, distribution: RandomDistribution<Self>) -> AnySequence<Self> {
        return AnySequence(randomIterator(maxCount: count, distribution: distribution))
    }

}
// MARK: Array
extension Array where Element: RandomDistribuableType {
    
    /// Construct an Array of random elements using `distribution`.
    public init(randomCount: Int, distribution: RandomDistribution<Element>) {
        self = Array(Element.randomSequence(maxCount: randomCount, distribution: distribution))
    }
    
}

// MARK: - implement RandomDistribuableType
extension Double: RandomDistribuableType {
    
    #if os(Linux)
    public func sqrt() -> Double { return Glibc.sqrt(self) }
    public func pow(_ value: Double) -> Double { return Glibc.pow(self, value) }
    public func exp() -> Double { return Glibc.exp(self) }
    public func log() -> Double { return Glibc.log(self) }
    // public func sin() -> Double { return Glibc.sin(self) }
    // public func cos() -> Double { return Glibc.cos(self) }
    #else
    public func sqrt() -> Double { return Darwin.sqrt(self) }
    public func pow(_ value: Double) -> Double { return Darwin.pow(self, value) }
    public func exp() -> Double { return Darwin.exp(self) }
    public func log() -> Double { return Darwin.log(self) }
    // public func cos() -> Double { return Darwin.cos(self) }
    // public func sin() -> Double { return Darwin.sin(self) }
    #endif

    public static var nextGaussianValue: Double? = nil
}


extension Float: RandomDistribuableType {
    #if os(Linux)
    public func sqrt() -> Float { return Glibc.sqrt(self) }
    public func pow(_ value: Float) -> Float { return Glibc.pow(self, value) }
    public func exp() -> Float { return Glibc.exp(self) }
    public func log() -> Float { return Glibc.log(self) }
    // public func sin() -> Float { return Glibc.sin(self) }
    // public func cos() -> Float { return Glibc.cos(self) }
    #else
    public func sqrt() -> Float { return Darwin.sqrt(self) }
    public func pow(_ value: Float) -> Float { return Darwin.pow(self, value) }
    public func exp() -> Float { return Darwin.exp(self) }
    public func log() -> Float { return Darwin.log(self) }
    // public func cos() -> Float { return Darwin.cos(self) }
    // public func sin() -> Float { return Darwin.sin(self) }
    #endif

    public static var nextGaussianValue: Float? = nil
}

