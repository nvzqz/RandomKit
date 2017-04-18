//
//  CollectionType+RandomKit.swift
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

extension Collection {

    internal var _indexRange: Range<Index> {
        return Range(uncheckedBounds: (startIndex, endIndex))
    }

    fileprivate func _boundsCheck(range: Range<Index>, line: UInt = #line) {
        if range.lowerBound < startIndex || range.upperBound > endIndex {
            fatalError("Range \(range) out of bounds", line: line)
        }
    }

}

extension Collection where Self: RandomRetrievable {

    /// Returns an optional random element in `self`. The result is `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element? {
        return isEmpty ? nil : uncheckedRandom(using: &randomGenerator)
    }

}

extension Collection where Self: RandomRetrievableInRange {

    /// Returns a random element in `self` without checking whether `self` is empty.
    public func uncheckedRandom<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element {
        return uncheckedRandom(in: _indexRange, using: &randomGenerator)
    }


    /// Returns an optional random element in `self`. The result is `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element? {
        let range = _indexRange
        return range.isEmpty ? nil : uncheckedRandom(in: range, using: &randomGenerator)
    }

    /// Returns an optional random element in `range`. The result is `nil` if `self` or `range` is empty.
    public func random<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Iterator.Element? {
        return isEmpty || range.isEmpty ? nil : uncheckedRandom(in: range, using: &randomGenerator)
    }

}

extension RandomRetrievableInRange where Self: Collection, Self.Index: RandomInRange {

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Iterator.Element {
        return self[Index.uncheckedRandom(in: range, using: &randomGenerator)]
    }

}

extension RandomRetrievableInRange where Self: Collection, Self.Index: RandomInRange, Self.IndexDistance: RandomToValue {

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Iterator.Element {
        return self[Index.uncheckedRandom(in: range, using: &randomGenerator)]
    }

}

extension Collection where Self: RandomRetrievableInRange, IndexDistance: RandomToValue {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Iterator.Element {
        let upper = range.upperBound
        let lower = range.lowerBound
        let elementIndex = IndexDistance.random(to: distance(from: lower, to: upper), using: &randomGenerator)
        return self[index(lower, offsetBy: elementIndex)]
    }

}

extension MutableCollection where Self: Shuffleable {

    /// Shuffles the elements of `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffle(using: &randomGenerator)
        return copy
    }

}

extension MutableCollection where Self: ShuffleableInRange {

    /// Shuffles the elements of `self` in `range` and returns the result.
    public func shuffled<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffle(in: range, using: &randomGenerator)
        return copy
    }

}

extension MutableCollection where Self: UniqueShuffleable {

    /// Shuffles the elements of `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffleUnique(using: &randomGenerator)
        return copy
    }

}

extension MutableCollection where Self: UniqueShuffleableInRange {

    /// Shuffles the elements of `self` in a unique order in `range` and returns the result.
    public func shuffledUnique<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffleUnique(in: range, using: &randomGenerator)
        return copy
    }

}

extension UnsafeBufferPointer: RandomRetrievableInRange {}

extension UnsafeMutableBufferPointer: RandomRetrievableInRange, ShuffleableInRange, UniqueShuffleableInRange {

    /// Shuffles the elements of `self`.
    public func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        shuffle(in: indices, using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in `range`.
    public func shuffle<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        for i in CountableRange(range) {
            let j = Int.uncheckedRandom(in: range, using: &randomGenerator)
            if j != i {
                swap(&self[i], &self[j])
            }
        }
    }

    /// Shuffles the elements of `self` in `range`.
    public func shuffle<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        shuffle(in: Range(range), using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order.
    public func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        shuffleUnique(in: indices, using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public func shuffleUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        if range.isEmpty {
            return
        }
        for i in CountableRange(uncheckedBounds: (range.lowerBound, range.upperBound &- 1)) {
            let randomRange = Range(uncheckedBounds: (i &+ 1, range.upperBound))
            let j = Int.uncheckedRandom(in: randomRange, using: &randomGenerator)
            swap(&self[i], &self[j])
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public func shuffleUnique<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        shuffleUnique(in: Range(range), using: &randomGenerator)
    }

}

extension UnsafeRawBufferPointer: RandomRetrievableInRange {}

extension UnsafeMutableRawBufferPointer: RandomRetrievableInRange, ShuffleableInRange, UniqueShuffleableInRange {

    private var _casted: UnsafeMutableBufferPointer<UInt8> {
        return UnsafeMutableBufferPointer(start: baseAddress?.assumingMemoryBound(to: UInt8.self), count: count)
    }

    /// Shuffles the elements of `self`.
    public func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        _casted.shuffle(using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in `range`.
    public func shuffle<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _casted.shuffle(in: range, using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in `range`.
    public func shuffle<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        shuffle(in: Range(range), using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order.
    public func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        _casted.shuffleUnique(using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public func shuffleUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _casted.shuffleUnique(in: range, using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public func shuffleUnique<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        shuffleUnique(in: Range(range), using: &randomGenerator)
    }

}

extension Array: RandomRetrievableInRange, ShuffleableInRange, UniqueShuffleableInRange {

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Element {
        let index = Int.uncheckedRandom(in: range, using: &randomGenerator)
        #if !swift(>=3.1)
            if let address = _buffer.firstElementAddressIfContiguous {
                return address[index]
            }
        #endif
        return self[index]
    }

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _boundsCheck(range: range)
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(in: range, using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _boundsCheck(range: range)
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(in: range, using: &randomGenerator)
        }
    }

}

extension ContiguousArray: RandomRetrievableInRange, ShuffleableInRange, UniqueShuffleableInRange {

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Element {
        let index = Int.uncheckedRandom(in: range, using: &randomGenerator)
        #if swift(>=3.1)
            return self[index]
        #else
            return _buffer.firstElementAddress[index]
        #endif
    }

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _boundsCheck(range: range)
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(in: range, using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _boundsCheck(range: range)
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(in: range, using: &randomGenerator)
        }
    }

}

extension ArraySlice: RandomRetrievableInRange, ShuffleableInRange, UniqueShuffleableInRange {

    private func _adjust(range: Range<Int>) -> Range<Int> {
        let diff = startIndex
        return Range(uncheckedBounds: (range.lowerBound &- diff, range.upperBound &- diff))
    }

    /// Returns a random element in `range` without checking whether `self` or `range` is empty.
    public func uncheckedRandom<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) -> Element {
        return self[Int.uncheckedRandom(in: range, using: &randomGenerator)]
    }

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _boundsCheck(range: range)
        let range = _adjust(range: range)
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(in: range, using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: Range<Int>, using randomGenerator: inout R) {
        _boundsCheck(range: range)
        let range = _adjust(range: range)
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(in: range, using: &randomGenerator)
        }
    }

}

extension CollectionOfOne: RandomRetrievableInRange {

    /// Returns a random element in `self` without checking whether `self` is empty.
    public func uncheckedRandom<R: RandomGenerator>(using randomGenerator: inout R) -> Element {
        return _unsafeBitCast(self)
    }

    /// Returns an optional random element in `self`. The result is `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Element? {
        return first
    }

}

extension Repeated: RandomRetrievableInRange {

    /// Returns a random element in `self` without checking whether `self` is empty.
    public func uncheckedRandom<R: RandomGenerator>(using randomGenerator: inout R) -> Element {
        return repeatedValue
    }

    /// Returns an optional random element in `self`. The result is `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Element? {
        return repeatedValue
    }

}

extension EmptyCollection: RandomRetrievableInRange {}
