//
//  FloatingPoint+RandomKit.swift
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

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

extension FloatingPoint where Self: RandomWithinClosedRange {

    /// Generates a random value of `Self`.
    public static func random(using randomGenerator: RandomGenerator) -> Self {
        return random(within: 0...1, using: randomGenerator)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Self>, using randomGenerator: RandomGenerator) -> Self {
        let multiplier = closedRange.upperBound - closedRange.lowerBound
        return closedRange.lowerBound + multiplier * (Self(UInt.random(using: randomGenerator)) / Self(UInt.max))
    }

}

extension Double: RandomWithinClosedRange {
}

extension Float: RandomWithinClosedRange {
}

#if os(macOS)
extension Float80: RandomWithinClosedRange {
}
#endif


// MARK: - implement RandomDistribuable
extension Double: RandomDistribuable {
    
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

extension Float: RandomDistribuable {
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

extension Double: BernoulliProbability {
    public static var bernouilliRange: ClosedRange<Double> { return 0...1 }
}

