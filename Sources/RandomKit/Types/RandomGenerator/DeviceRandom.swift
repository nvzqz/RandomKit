//
//  DeviceRandom.swift
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

import Foundation

/// A device generator at "/dev/random" or "/dev/urandom".
public final class DeviceRandom: RandomGenerator {

    /// The device source.
    public enum Source: String {

        /// random device.
        case random

        /// urandom device.
        case urandom

        /// The path for the device.
        public var path: String {
            return "/dev/" + rawValue
        }

    }

    /// A default global instance.
    public static var `default` = DeviceRandom(source: .urandom)

    private let _fileDescriptor: Int32

    /// Creates an instance by opening a file descriptor to the device at `source`.
    public init(source: Source) {
        self._fileDescriptor = open(source.path, O_RDONLY)
    }

    deinit {
        close(_fileDescriptor)
    }

    /// Randomizes the contents of `buffer` up to `size`.
    public func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
        read(_fileDescriptor, buffer, size)
    }

}
