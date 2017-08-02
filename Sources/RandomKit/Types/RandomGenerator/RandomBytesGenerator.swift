//
//  RandomBytesGenerator.swift
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

#if swift(>=3.1)
/// A workaround to make `RandomBytesGenerator` a `Sequence` for Swift 3.1+.
public typealias _RandomBytesGeneratorComposition = RandomGenerator & Sequence
#else
public typealias _RandomBytesGeneratorComposition = RandomGenerator
#endif

/// A type that specializes in generating random bytes in the form of a `Bytes` type.
public protocol RandomBytesGenerator: _RandomBytesGeneratorComposition {

    /// A type that stores bytes within its own value.
    associatedtype Bytes

    /// Returns random `Bytes`.
    mutating func randomBytes() -> Bytes

    #if swift(>=3.1)
    /// Returns an iterator over the elements of this sequence.
    func makeIterator() -> RandomBytesIterator<Self>
    #endif

}

#if swift(>=3.1)

/// An iterator over the `Byte`s of a `RandomBytesGenerator` source.
///
/// ```
/// func perform(with randomValue: UInt64) -> Bool {
///     ...
/// }
///
/// for x in Xoroshiro.seeded {
///     guard perform(with: x) else {
///         break
///     }
///     ...
/// }
/// ```
public struct RandomBytesIterator<Source: RandomBytesGenerator>: IteratorProtocol {

    /// The source generator from which `next()` retrieves values.
    public var source: Source

    /// Advances to the next element and returns it.
    public mutating func next() -> Source.Bytes? {
        return source.randomBytes()
    }

}

extension RandomBytesGenerator {
    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> RandomBytesIterator<Self> {
        return RandomBytesIterator(source: self)
    }
}

#endif

extension RandomBytesGenerator where Bytes == UInt64 {

    /// Generates a random unsigned 64-bit integer.
    public mutating func random64() -> UInt64 {
        return randomBytes()
    }

    /// Generates a random unsigned 32-bit integer.
    public mutating func random32() -> UInt32 {
        #if swift(>=3.2)
            return UInt32(extendingOrTruncating: randomBytes())
        #else
            return UInt32(truncatingBitPattern: randomBytes())
        #endif
    }

    /// Generates a random unsigned 16-bit integer.
    public mutating func random16() -> UInt16 {
        #if swift(>=3.2)
            return UInt16(extendingOrTruncating: randomBytes())
        #else
            return UInt16(truncatingBitPattern: randomBytes())
        #endif
    }

    /// Generates a random unsigned 8-bit integer.
    public mutating func random8() -> UInt8 {
        #if swift(>=3.2)
            return UInt8(extendingOrTruncating: randomBytes())
        #else
            return UInt8(truncatingBitPattern: randomBytes())
        #endif
    }

}

extension RandomBytesGenerator where Bytes == UInt32 {

    /// Generates a random unsigned 64-bit integer.
    public mutating func random64() -> UInt64 {
        return _unsafeBitCast((randomBytes(), randomBytes()))
    }

    /// Generates a random unsigned 32-bit integer.
    public mutating func random32() -> UInt32 {
        return randomBytes()
    }

    /// Generates a random unsigned 16-bit integer.
    public mutating func random16() -> UInt16 {
        #if swift(>=3.2)
            return UInt16(extendingOrTruncating: randomBytes())
        #else
            return UInt16(truncatingBitPattern: randomBytes())
        #endif
    }

    /// Generates a random unsigned 8-bit integer.
    public mutating func random8() -> UInt8 {
        #if swift(>=3.2)
            return UInt8(extendingOrTruncating: randomBytes())
        #else
            return UInt8(truncatingBitPattern: randomBytes())
        #endif
    }

}

extension RandomBytesGenerator {

    /// Randomizes the contents of `buffer` up to `size`.
    public mutating func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        let bytesBuffer = buffer.assumingMemoryBound(to: Bytes.self)
        for i in CountableRange(uncheckedBounds: (0, size / MemoryLayout<Bytes>.size)) {
            bytesBuffer[i] = randomBytes()
        }
        let remainder = size % MemoryLayout<Bytes>.size
        if remainder > 0 {
            var remaining = randomBytes()
            let remainingBuffer = buffer.advanced(by: size &- remainder)
            remainingBuffer.copyBytes(from: &remaining, count: remainder)
        }
    }

}
