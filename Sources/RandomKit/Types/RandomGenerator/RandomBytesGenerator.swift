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

/// A type that specializes in generating random bytes in the form of a `Bytes` type.
public protocol RandomBytesGenerator: RandomGenerator {

    /// A type that stores bytes within its own value.
    associatedtype Bytes

    /// Returns random `Bytes`.
    mutating func randomBytes() -> Bytes

}

extension RandomBytesGenerator where Bytes == UInt64 {

    /// Generates a random 64-bit integer.
    public mutating func random64() -> UInt64 {
        return randomBytes()
    }

}

extension RandomBytesGenerator where Bytes == UInt32 {

    /// Generates a random 32-bit integer.
    public mutating func random32() -> UInt32 {
        return randomBytes()
    }

}

extension RandomBytesGenerator {

    /// Randomizes the contents `buffer` up to `size`.
    public mutating func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        let bytesBuffer = buffer.assumingMemoryBound(to: Bytes.self)
        for i in CountableRange(uncheckedBounds: (0, size / MemoryLayout<Bytes>.size)) {
            bytesBuffer[i] = randomBytes()
        }
        let remainder = size % MemoryLayout<Bytes>.size
        if remainder > 0 {
            var remaining = randomBytes()
            let remainingBuffer = buffer.assumingMemoryBound(to: UInt8.self)
            withUnsafePointer(to: &remaining) { remainingPtr in
                remainingPtr.withMemoryRebound(to: UInt8.self, capacity: remainder) { r in
                    for i in CountableRange(uncheckedBounds: (0, remainder)) {
                        remainingBuffer[size - i - 1] = r[i]
                    }
                }
            }
        }
    }

}
