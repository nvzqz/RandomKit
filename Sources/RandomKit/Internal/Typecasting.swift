//
//  Typecasting.swift
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

/// Same as `unsafeBitCast(_:to:)` except the output type is inferred.
@inline(__always)
internal func _unsafeBitCast<T, U>(_ value: T) -> U {
    return unsafeBitCast(value, to: U.self)
}

// Allows casting between types of potentially different sizes.

internal func _unsafeCast<T, U>(_ value: inout T, to type: U.Type = U.self) -> U {
    return UnsafeMutableRawPointer(&value).assumingMemoryBound(to: type).pointee
}

internal func _unsafeCast<T, U>(_ value: T, to type: U.Type = U.self) -> U {
    var value = value
    return _unsafeCast(&value, to: type)
}

/// Unsafely creates a new value of type `T`.
internal func _unsafeValue<T>(of type: T.Type = T.self) -> T {
    return _unsafeCast(Optional<T>.none)
}

//internal func _pointer<T, U>(to value: inout T, as type: U.Type = U.self) -> UnsafeMutablePointer<U> {
//    return UnsafeMutableRawPointer(&value).assumingMemoryBound(to: type)
//}
