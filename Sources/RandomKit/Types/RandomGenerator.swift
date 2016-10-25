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

    /// Use arc4random. Does nothing on Linux.
    case arc4random

    /// Use "/dev/random".
    case devRandom

    /// Use "/dev/urandom".
    case devURandom

    /// Use custom generator.
    case custom(randomize: (UnsafeMutableRawPointer, Int) -> ())

    #if !os(Linux)

    /// The default random generator.
    static var `default` = arc4random

    #else

    /// The default random generator.
    static var `default` = devURandom

    #endif

    /// Randomize the contents of `buffer` of `size`.
    public func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        switch self {
        case .arc4random:
            #if !os(Linux)
                arc4random_buf(buffer, size)
            #endif
        case .devRandom:
            let fd = open("/dev/random", O_RDONLY)
            read(fd, buffer, size)
            close(fd)
        case .devURandom:
            let fd = open("/dev/urandom", O_RDONLY)
            read(fd, buffer, size)
            close(fd)
        case let .custom(randomize):
            randomize(buffer, size)
        }
    }

}
