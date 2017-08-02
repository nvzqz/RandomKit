//
//  ChaCha.swift
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

/// A generator that uses a [ChaCha20][1] algorithm. There is also a [Wikipedia section][2] describing this algorithm.
///
/// This implementation is taken from that of [ChaCha][3] in the Rust `rand` crate.
///
/// [1]: http://cr.yp.to/chacha.html
/// [2]: https://en.wikipedia.org/wiki/Salsa20#ChaCha_variant
/// [3]: https://doc.rust-lang.org/rand/rand/chacha/struct.ChaChaRng.html
public struct ChaCha: RandomBytesGenerator, Seedable, SeedableFromSequence, SeedableFromRandomGenerator {

    /// The seed type.
    public typealias Seed = [UInt32]

    /// The seed sequence's element type.
    public typealias SeedSequenceElement = UInt32

    private typealias _State = _Array16<UInt32>

    private static let _stateCount = 16

    private static let _keyCount = 8

    private static let _rounds = 20

    private static var _empty: ChaCha {
        return ChaCha(_buffer: _zero16(), _state: _zero16(), _index: _stateCount)
    }

    /// A default global instance seeded with `DeviceRandom.default`.
    public static var `default` = seeded

    /// A default global instance that reseeds itself with `DeviceRandom.default`.
    public static var defaultReseeding = reseeding

    /// Returns an unseeded instance.
    public static var unseeded: ChaCha {
        var result = _empty
        result._reset()
        return result
    }

    private var _buffer: _State

    private var _state: _State

    private var _index: Int

    private var _bufferPointer: UnsafeMutablePointer<UInt32> {
        mutating get { return UnsafeMutablePointer(&_buffer.0) }
    }

    private var _statePointer: UnsafeMutablePointer<UInt32> {
        mutating get { return UnsafeMutablePointer(&_state.0) }
    }

    private init(_buffer: _State, _state: _State, _index: Int) {
        self._buffer = _buffer
        self._state = _state
        self._index = _index
    }

    /// Creates an instance from `seed`.
    public init<S: Sequence>(seed: S) where S.Iterator.Element == UInt32 {
        self = ._empty
        reseed(with: seed)
    }

    /// Creates an instance seeded with `randomGenerator`.
    public init<R: RandomGenerator>(seededWith randomGenerator: inout R) {
        var seed: _Array8<UInt32> = randomGenerator.randomUnsafeValue()
        self.init(seed: UnsafeBufferPointer(start: &seed.0, count: ChaCha._keyCount))
    }

    private mutating func _reset() {
        _state.0 = 0x61707865
        _state.1 = 0x3320646E
        _state.2 = 0x79622D32
        _state.3 = 0x6B206574
        let pointer = UnsafeMutablePointer(&_state.4)
        for i in 0 ..< 12 {
            pointer[i] = 0
        }
        _index = ChaCha._stateCount
    }

    private mutating func _update() {
        let bufferPtr = _bufferPointer
        let statePtr  = _statePointer
        _buffer = _state
        _index = 0
        for _ in 0 ..< ChaCha._rounds / 2 {
            _doubleRound(bufferPtr)
        }
        for i in 0 ..< ChaCha._stateCount {
            bufferPtr[i] = bufferPtr[i] &+ statePtr[i]
        }
        for i in 12 ..< 16 {
            statePtr[i] = statePtr[i] &+ 1
            guard statePtr[i] == 0 else {
                return
            }
        }
    }

    /// Sets the internal 128-bit counter.
    public mutating func setCounter(low: UInt64, high: UInt64) {
        #if swift(>=3.2)
            _state.12 = UInt32(extendingOrTruncating: low)
            _state.13 = UInt32(extendingOrTruncating: low &>> 32)
            _state.14 = UInt32(extendingOrTruncating: high)
            _state.15 = UInt32(extendingOrTruncating: high &>> 32)
        #else
            _state.12 = UInt32(truncatingBitPattern: low)
            _state.13 = UInt32(truncatingBitPattern: low >> 32)
            _state.14 = UInt32(truncatingBitPattern: high)
            _state.15 = UInt32(truncatingBitPattern: high >> 32)
        #endif
        _index = ChaCha._stateCount
    }

    /// Reseeds `self` with `seed`.
    public mutating func reseed<S: Sequence>(with seed: S) where S.Iterator.Element == UInt32 {
        _reset()
        var iter = seed.makeIterator()
        let keyPointer = _statePointer
        for i in 4 ..< ChaCha._keyCount + 4 {
            guard let s = iter.next() else {
                break
            }
            keyPointer[i] = s
        }
    }

    /// Returns random `Bytes`.
    public mutating func randomBytes() -> UInt32 {
        if _index == ChaCha._stateCount {
            _update()
        }
        defer { _index += 1 }
        return _bufferPointer[_index % ChaCha._stateCount]
    }

}

extension UInt32 {
    @inline(__always)
    fileprivate func _rotateLeft(_ n: UInt32) -> UInt32 {
        return (self << n) | (self >> (32 &- n))
    }
}

@inline(__always)
private func _quarterRound(_ a: inout UInt32, _ b: inout UInt32, _ c: inout UInt32, _ d: inout UInt32) {
    a = a &+ b; d ^= a; d = d._rotateLeft(16)
    c = c &+ d; b ^= c; b = b._rotateLeft(12)
    a = a &+ b; d ^= a; d = d._rotateLeft(8)
    c = c &+ d; b ^= c; b = b._rotateLeft(7)
}

@inline(__always)
private func _doubleRound(_ x: UnsafeMutablePointer<UInt32>) {
    // Column round
    _quarterRound(&x[0], &x[4], &x[8],  &x[12])
    _quarterRound(&x[1], &x[5], &x[9],  &x[13])
    _quarterRound(&x[2], &x[6], &x[10], &x[14])
    _quarterRound(&x[3], &x[7], &x[11], &x[15])
    // Diagonal round
    _quarterRound(&x[0], &x[5], &x[10], &x[15])
    _quarterRound(&x[1], &x[6], &x[11], &x[12])
    _quarterRound(&x[2], &x[7], &x[8],  &x[13])
    _quarterRound(&x[3], &x[4], &x[9],  &x[14])
}
