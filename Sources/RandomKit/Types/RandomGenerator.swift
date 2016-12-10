//
//  RandomGenerator.swift
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

/// A random generator.
public enum RandomGenerator {

    /// The device source for `RandomGenerator.device`.
    public enum DeviceSource: String, CustomStringConvertible {

        /// random device.
        case random

        /// urandom device.
        case urandom

        /// A textual representation of this instance.
        public var description: String {
            return rawValue
        }

        /// The path for the device.
        public var path: String {
            return "/dev/" + rawValue
        }

    }

    /// Use arc4random.
    ///
    /// If the OS is Linux, Android, or Windows, `arc4random_buf` will be attempted to be dynamically loaded.
    case arc4Random

    /// Use device at "/dev/random" or "/dev/urandom". Does nothing on Windows unless using Cygwin.
    case device(DeviceSource)

    /// Use Xoroshiro algorithm.
    ///
    /// More info can be found [here](http://xoroshiro.di.unimi.it/).
    ///
    /// If `threadSafe` is `true`, a mutex will be used to access the internal state.
    case xoroshiro(threadSafe: Bool)

    /// Use [Mersenne Twister](https://en.wikipedia.org/wiki/Mersenne_Twister) algorithm.
    ///
    /// If `threadSafe` is `true`, a mutex will be used to access the internal state.
    case mersenneTwister(threadSafe: Bool)

    /// Use custom generator.
    case custom(randomize: (UnsafeMutableRawPointer, Int) -> ())

    /// The default random generator. Initially `xoroshiro(threadSafe: true)`.
    public static var `default` = xoroshiro(threadSafe: true)

    /// Whether `arc4random` is available on the current system.
    public static var arc4RandomIsAvailable: Bool {
        #if !os(Linux) && !os(Android) && !os(Windows)
            return true
        #else
            if case .some = _a4r_buf {
                return true
            } else {
                return false
            }
        #endif
    }

    /// Randomize the contents of `buffer` of `size` bytes.
    public func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        switch self {
        case .arc4Random:
            _arc4random_buf(buffer, size)
        case let .device(source):
            #if !os(Windows) || CYGWIN
            let fd = open(source.path, O_RDONLY)
            read(fd, buffer, size)
            close(fd)
            #endif
        case let .xoroshiro(threadSafe):
            if threadSafe {
                _Xoroshiro.randomizeThreadSafe(buffer: buffer, size: size)
            } else {
                _Xoroshiro.randomize(buffer: buffer, size: size)
            }
        case let .mersenneTwister(threadSafe):
            if threadSafe {
                _MersenneTwister.randomizeThreadSafe(buffer: buffer, size: size)
            } else {
                _MersenneTwister.randomize(buffer: buffer, size: size)
            }
        case let .custom(randomize):
            randomize(buffer, size)
        }
    }

    /// Randomize the contents of `buffer` with max `width` bits.
    public func randomize(buffer: UnsafeMutableRawPointer, maxWidth width: Int) {
        guard width > 0 else {
            return
        }
        let byteCount = (width + 7) / 8
        randomize(buffer: buffer, size: byteCount)
        let count = width % 8
        if count != 0 {
            let rebounded = buffer.assumingMemoryBound(to: UInt8.self)
            rebounded[byteCount - 1] &= .max >> UInt8(8 - count)
        }
    }

    /// Randomize the contents of `buffer` with exactly `width` bits.
    public func randomize(buffer: UnsafeMutableRawPointer, exactWidth width: Int) {
        guard width > 0 else {
            return
        }
        randomize(buffer: buffer, maxWidth: width)
        let byteCount = (width + 7) / 8
        let rebounded = buffer.assumingMemoryBound(to: UInt8.self)
        rebounded[byteCount - 1] |= 1 << UInt8((width - 1) % 8)
    }

    /// Randomize the contents of `value`.
    public func randomize<T>(value: inout T) {
        randomize(buffer: &value, size: MemoryLayout<T>.size)
    }

}

private struct _Xoroshiro {

    private static var _instance = _Xoroshiro()

    private static var _mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()

    static func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        _instance.randomize(buffer: buffer, size: size)
    }

    static func randomizeThreadSafe(buffer: UnsafeMutableRawPointer, size: Int) {
        pthread_mutex_lock(&_mutex)
        randomize(buffer: buffer, size: size)
        pthread_mutex_unlock(&_mutex)
    }

    var state: (UInt64, UInt64)

    init(state: (UInt64, UInt64)) {
        self.state = state
    }

    init() {
        self.init(state: (0, 0))
        RandomGenerator.device(.urandom).randomize(buffer: &state, size: MemoryLayout.size(ofValue: state))
    }

    mutating func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        buffer._randomize(size: size, using: {
            let (l, k0, k1, k2): (UInt64, UInt64, UInt64, UInt64) = (64, 55, 14, 36)
            let result = state.0 &+ state.1
            let x = state.0 ^ state.1
            state.0 = ((state.0 << k0) | (state.0 >> (l - k0))) ^ x ^ (x << k1)
            state.1 = (x << k2) | (x >> (l - k2))
            return result
        })
    }

}

private struct _MersenneTwister {

    private static var _instance = _MersenneTwister()

    private static var _mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()

    static func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        _instance.randomize(buffer: buffer, size: size)
    }

    static func randomizeThreadSafe(buffer: UnsafeMutableRawPointer, size: Int) {
        pthread_mutex_lock(&_mutex)
        randomize(buffer: buffer, size: size)
        pthread_mutex_unlock(&_mutex)
    }

    private static let stateCount: Int = 312

    var state: (
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,

        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,

        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,

        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64
    ) = (
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    )

    var index: Int

    init() {
        index = _MersenneTwister.stateCount
        let seed = UInt64.random(using: .device(.urandom))
        withUnsafeMutablePointer(to: &state) { pointer in
            pointer.withMemoryRebound(to: UInt64.self, capacity: _MersenneTwister.stateCount) { state in
                state[0] = seed
                for i in 1 ..< _MersenneTwister.stateCount {
                    state[i] = 6364136223846793005 &* (state[i &- 1] ^ (state[i &- 1] >> 62)) &+ UInt64(i)
                }
            }
        }
    }

    mutating func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        buffer._randomize(size: size) {
            if index == _MersenneTwister.stateCount {
                let state = withUnsafeMutablePointer(to: &self.state) {
                    $0.withMemoryRebound(to: UInt64.self, capacity: _MersenneTwister.stateCount) {
                        $0
                    }
                }

                let n = _MersenneTwister.stateCount
                let m = n / 2
                let a: UInt64 = 0xB5026F5AA96619E9
                let lowerMask: UInt64 = (1 << 31) - 1
                let upperMask: UInt64 = ~lowerMask
                var (i, j, stateM) = (0, m, state[m])
                repeat {
                    let x1 = (state[i] & upperMask) | (state[i &+ 1] & lowerMask)
                    state[i] = state[i &+ m] ^ (x1 >> 1) ^ ((state[i &+ 1] & 1) &* a)
                    let x2 = (state[j] & upperMask) | (state[j &+ 1] & lowerMask)
                    state[j] = state[j &- m] ^ (x2 >> 1) ^ ((state[j &+ 1] & 1) &* a)
                    (i, j) = (i &+ 1, j &+ 1)
                } while i != m &- 1

                let x3 = (state[m &- 1] & upperMask) | (stateM & lowerMask)
                state[m &- 1] = state[n &- 1] ^ (x3 >> 1) ^ ((stateM & 1) &* a)
                let x4 = (state[n &- 1] & upperMask) | (state[0] & lowerMask)
                state[n &- 1] = state[m &- 1] ^ (x4 >> 1) ^ ((state[0] & 1) &* a)

                index = 0
            }

            var result = withUnsafePointer(to: &state) {
                $0.withMemoryRebound(to: UInt64.self, capacity: _MersenneTwister.stateCount) { ptr in
                    return ptr[index]
                }
            }
            index = index &+ 1
            
            result ^= (result >> 29) & 0x5555555555555555
            result ^= (result << 17) & 0x71D67FFFEDA60000
            result ^= (result << 37) & 0xFFF7EEE000000000
            result ^= result >> 43
            
            return result
        }
    }

}

private extension UnsafeMutableRawPointer {

    @inline(__always)
    func _randomize(size: Int, using random: () -> UInt64) {
        let uInt64Buffer = assumingMemoryBound(to: UInt64.self)
        for i in 0 ..< (size / 8) {
            uInt64Buffer[i] = random()
        }
        let remainder = size % 8
        if remainder > 0 {
            var remaining = random()
            let uInt8Buffer = assumingMemoryBound(to: UInt8.self)
            withUnsafePointer(to: &remaining) { remainingPtr in
                remainingPtr.withMemoryRebound(to: UInt8.self, capacity: remainder) { r in
                    for i in 0 ..< remainder {
                        uInt8Buffer[size - i - 1] = r[i]
                    }
                }
            }
        }
    }

}

#if os(Linux) || os(Android) || os(Windows)

private typealias _Arc4random_buf = @convention(c) (ImplicitlyUnwrappedOptional<UnsafeMutableRawPointer>, Int) -> ()

private let _a4r_buf: _Arc4random_buf? = {
    guard let handle = dlopen(nil, RTLD_NOW) else {
        return nil
    }
    defer {
        dlclose(handle)
    }
    guard let a4r = dlsym(handle, "arc4random_buf") else {
        return nil
    }
    return unsafeBitCast(a4r, to: _Arc4random_buf.self)
}()

#endif

/// Performs `arc4random_buf` if OS is not Linux, Android, or Windows. Otherwise it'll try
/// getting the handle for `arc4random_buf` and use the result if successful.
private func _arc4random_buf(_ buffer: UnsafeMutableRawPointer!, _ size: Int) {
    #if !os(Linux) && !os(Android) && !os(Windows)
        arc4random_buf(buffer, size)
    #else
        _a4r_buf?(buffer, size)
    #endif
}
