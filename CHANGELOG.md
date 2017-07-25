# Change Log

All releases of RandomKit adhere to [Semantic Versioning](http://semver.org/).

---

## [v5.2.0](https://github.com/nvzqz/RandomKit/tree/v5.2.0) (2017-07-25)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v5.1.0...v5.2.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v5.2.0)

### New Features
- Made `Trivial` protocol public, allowing for library users to enable related optimizations for their own types
- Added `jump(count:)` variant of `jump()` to `Xoroshiro` and `XorshiftStar`

### Improvements
- Made `jump()` for `XorshiftStar` 20%+ faster
- Made `reseed(with:)` for `ChaCha` 550%+ faster
    - `init(seed:)` is also faster due to reliance on `reseed(with:)`

---

## [v5.1.0](https://github.com/nvzqz/RandomKit/tree/v5.1.0) (2017-06-24)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v5.0.0...v5.1.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v5.1.0)

### Improvements
- Initial Swift 4 compatibility :tada:
- Improved time to access a thread-local generator by ~22%
    - Adds [Threadly](https://github.com/nvzqz/Threadly) dependency

### Changes
- The ShiftOperations package is not required for Swift 3.2 and above

---

## [v5.0.0](https://github.com/nvzqz/RandomKit/tree/v5.0.0) (2017-05-31)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.5.2...v5.0.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v5.0.0)

### New Features
- Added `RandomRetrievable` and `RandomRetrievableInRange` protocols
- Added `SeedableFromSequence` protocol

### Changes
- Removed `random(using:)` method that applied to all `Sequence` types
- Removed `Double` `random(within:using:)` for `TimeInterval` ranges
- Renamed `RandomWithinRange` and `RandomWithinClosedRange` to `RandomInRange` and `RandomInClosedRange` respectively
    - Functions that had a `within:` argument now use `in:`
- `SeedableFromRandomGenerator` no longer requires `Seedable`
- Changed `ChaCha.Seed` to `[UInt32]`

---

## [v4.5.2](https://github.com/nvzqz/RandomKit/tree/v4.5.2) (2017-04-13)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.5.1...v4.5.2)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.5.2)

### Fixes
- Fixed `Xoroshiro` jump method

---

## [v4.5.1](https://github.com/nvzqz/RandomKit/tree/v4.5.1) (2017-04-12)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.5.0...v4.5.1)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.5.1)

### Fixes
- `ChaCha` `reseed(with:)` did not generate the same values for the same seed it was instantiated with

---

## [v4.5.0](https://github.com/nvzqz/RandomKit/tree/v4.5.0) (2017-04-12)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.4.1...v4.5.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.5.0)

### New Features
- ChaCha random number generator
- Added `reseed()` method to `SeedableFromOtherRandomGenerator`

### Improvements
- Make random `Array` initializers 5-10% faster

---

## [v4.4.1](https://github.com/nvzqz/RandomKit/tree/v4.4.1) (2017-03-30)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.4.0...v4.4.1)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.4.1)

### Fixes
- Safely accesses internal global thread-local-storage type keys dictionary with a readers-write lock

---

## [v4.4.0](https://github.com/nvzqz/RandomKit/tree/v4.4.0) (2017-03-30)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.3.1...v4.4.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.4.0)

### New Features
- Added initializers to `ReseedingRandomGenerator` that take 1 or 0 arguments
    - If `Reseeder` conforms to `SeedableFromOtherRandomGenerator`, the reseeder is created from `Reseeder.seeded`
    - For Swift >= 3.1, if `Reseeder` is `DeviceRandom` or `ARC4Random`, the reseeder is just `Reseeder.default`
- Added floating-point value generation methods for open, half open, and closed intervals
- Added [thread-local random generators](https://github.com/nvzqz/RandomKit#thread-safety) :tada:

### Improvements
- Made `Double` and `Float` `random(using:)` about 27 times faster
- Made `CGFloat.random(using:)` faster , in turn making `(NS|UI)Color.random(using:)` faster

### Fixes
- Made `randomClosed` methods be truly on the [0, 1] interval

---

## [v4.3.1](https://github.com/nvzqz/RandomKit/tree/v4.3.1) (2017-03-21)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.3.0...v4.3.1)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.3.1)

### Changes
- Random `Date`s are internally relative to `timeIntervalSinceReferenceDate`
- Deprecated `Date` `random(within:using:)` for `TimeInterval` ranges

---

## [v4.3.0](https://github.com/nvzqz/RandomKit/tree/v4.3.0) (2017-03-21)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.2.0...v4.3.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.3.0)

### New Features
- Added `SeedableFromOtherRandomGenerator` protocol
    - Allows for creating a `RandomGenerator` seeded from another `RandomGenerator`
- Added `ReseedingRandomGenerator` struct for reseeding a base `RandomGenerator` with another after a certain number of bytes have been generated

### Improvements
- Much faster Array `random(using:)` for Swift versions before 3.1

### Fixes
- Fix compilation issues by not using API unavailable in Swift 3.1

---

## [v4.2.0](https://github.com/nvzqz/RandomKit/tree/v4.2.0) (2017-03-15)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.1.0...v4.2.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.2.0)

### Improvements

- Made Array `init(randomCount:using:)` about 4 times faster for integer types by having it safely call `init(unsafeRandomCount:using:)`

- Made Dictionary shuffling faster

### Changes

- Made Array `init(unsafeRandomCount:using:)` available for all element types, regardless if they conform to `UnsafeRandom`

---

## [v4.1.0](https://github.com/nvzqz/RandomKit/tree/v4.1.0) (2017-03-15)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v4.0.0...v4.1.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.1.0)

### New Features
- Added `seeded` static variable to `Xoroshiro`, `Xorshift`, `XorshiftStar`, and `MersenneTwister`

### Improvements
- Made the `init(randomCount:using:)` family of `Array` initializers significantly faster

---

## [v4.0.0](https://github.com/nvzqz/RandomKit/tree/v4.0.0) (2017-03-06)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v3.0.0...v4.0.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v4.0.0)

### New Features
- Added `randoms(using:)` methods to `Random-` types that return a sequence of random values according to the protocol's specialization
- Added `Bool.random(withWeight:using:)` for probability
- Added more random number generators:
    - `Xorshift`
    - `XorshiftStar`
- `NSMutableArray` now conforms to `Shuffleable` and `UniqueShuffleable`
- Added `randomTuple(using:)` global functions for creating tuples of up to six random elements
- Added `ShuffleableInRange` and `UniqueShuffleableInRange` protocols

### Improvements
- Much better `init(randomCount:using:)` performance for `Array` and `Dictionary`
- `Array` shuffling is ten times faster
- Much better performance for `random(within:using:)` for signed integers

### Changes
- Changed `RandomGenerator` from an enum to a protocol type
  - As a result, there is no default generator, meaning a generator must be specified as a parameter
- Random generation functions take a generic `RandomGenerator` type as an `inout` argument
- Removed `URL` conformance to `Random`

---

## [v3.0.0](https://github.com/nvzqz/RandomKit/tree/v3.0.0) (2016-12-09)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v2.3.0...v3.0.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v3.0.0)

### New Features
- [Mersenne Twister](https://en.wikipedia.org/wiki/Mersenne_Twister) random generator
- All integer types conform to `UnsafeRandom`
- `Array(unsafeRandomCount:using:)` for types conforming to `UnsafeRandom`
    - For much better performance with integer types, this should be used
- Added a benchmark target that can be built with the Swift package manager
- Created `RandomWithMaxWidth` and `RandomWithExactWidth` protocols
- Added `randomize(buffer:maxWidth:)` and `randomize(buffer:exactWidth:)` methods to `RandomGenerator`

### Improvements
- Generating `RandomEnum` values is significantly faster

### Fixes
- `UnicodeScalar` now produces a uniform distribution when the `Range` or `ClosedRange` spans below `0xD7FF` and above `0xE000`

### Changes
- Removed `RandomDistribution` (#29)
- The `devRandom` and `devURandom` cases for `RandomGenerator` are now a single `device` case with a `DeviceSource` parameter
- The `arc4random` case for `RandomGenerator` is now camel-cased `arc4Random`
- `Float80` extension now available for i386 and x86_64 architectures, not only for macOS
- `URL.random(fromValues:)` now returns an `Optional<URL>`
- Added [ShiftOperations](https://github.com/nvzqz/ShiftOperations) dependency
- Uses `Strideable` instead of `_Strideable`

---

## [v2.3.0](https://github.com/nvzqz/RandomKit/tree/v2.3.0) (2016-11-21)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v2.2.1...v2.3.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v2.3.0)

### New Features
- `Date` now conforms to `RandomWithinRange`
- Made unicode scalar based string generation faster
- Created `UnsafeRandom`, `RandomEnum`, `RandomWithAll`, and `RandomRawRepresentable` protocols

### Fixes
- Fix which random generator is used for random String. Previously used the default instead of the one passed into the function.

---

## [v2.2.1](https://github.com/nvzqz/RandomKit/tree/v2.2.1) (2016-11-08)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v2.2.0...v2.2.1)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v2.2.1)

### Fixes
- Conformance to `Random` was removed accidentally for types conforming to `FloatingPoint`. This has been fixed.

---

## [v2.2.0](https://github.com/nvzqz/RandomKit/tree/v2.2.0) (2016-11-07)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v2.1.0...v2.2.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v2.2.0)

### Fixes
- Random `Int` generation would rely on the size of `UIntMax` which was apparently not reliable (#28)

### Changes
- If on Linux, Android, or Windows, the `arc4random_buf` function will be dynamically loaded, making the `RandomGenerator.arc4random` option more widely available
- Removed default parameter for `randomGenerator` for the `random(using:)` function of `Range` types
- Removed `Random` protocol dependency from `Random-` protocols

---

## [v2.1.0](https://github.com/nvzqz/RandomKit/tree/v2.1.0) (2016-10-29)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v2.0.0...v2.1.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v2.1.0)

### Improvements
- Range types now have `random` and `random(using:)` for when bounds are `RandomWithinRange` and `RandomWithinClosedRange` types
- Improved performance for retrieving random elements from collections

### Fixes
- Fixed `random(within:)` for unsigned integers

---

## [v2.0.0](https://github.com/nvzqz/RandomKit/tree/v2.0.0) (2016-10-28)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.6.0...v2.0.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v2.0.0)

### Changes
- Swift 3 compatibility
- A bunch of protocols/types

---

## [v1.6.0](https://github.com/nvzqz/RandomKit/tree/v1.6.0) (2015-11-21)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.5.0...v1.6.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.6.0)

### New Features
- `randomGenerator()` and `randomSequence()` for `RandomType` that return an infinite number of random values
- New `ShuffleType` protocol for types that can return its values shuffled
    - Array and Dictionary can be shuffled
- New `RandomIntervalType` protocol that allows for getting a random value within a closed interval
    - Random generators and sequences can be made within a closed interval
- Getting random slices of an Array ([Phi Mage](https://github.com/phimage) #10)

### Changes
- Deleted `String.RandomLength` and `NSURL.RandomValues`

---

## [v1.5.0](https://github.com/nvzqz/RandomKit/tree/v1.5.0) (2015-10-25)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.4.0...v1.5.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.5.0)

### New Features
- tvOS support :tv:
- Added random generators to types in the CoreGraphics module as well as `NSNumber`
- Removed the Foundation import for extensions of Swift types (only 'stdlib.h' is needed for arc4random)

### Changes
- Relevant Objective-C types now conform to `RandomType`

---

## [v1.4.0](https://github.com/nvzqz/RandomKit/tree/v1.4.0) (2015-10-17)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.3.0...v1.4.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.4.0)

### New Features
- Random phone number generator
- Random gender generator
- Random English honorific generator according to type and gender
- Another `CGFloat` random generator with interval parameter

### Changes
- Faster `Double`, `Float`, and `CGFloat` generation
- `CGFloat` value generation is now dependent on its `NativeType`

---

## [v1.3.0](https://github.com/nvzqz/RandomKit/tree/v1.3.0) (2015-10-14)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.2.0...v1.3.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.3.0)

### New Features
- Added `random` property to `SequenceType` that returns a random element, or `nil` if the sequence is empty.
- Added `random()` static method to `Bit`, that returns `One` or `Zero` with a 50/50 chance of either.

---

## [v1.2.0](https://github.com/nvzqz/RandomKit/tree/v1.2.0) (2015-10-12)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.1.0...v1.2.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.2.0)

### New Features
- Random generators for `NSDate` and `NSURL` have been added

### Changes
- Parameter for `Color.random()` is now named #1

---

## [v1.1.0](https://github.com/nvzqz/RandomKit/tree/v1.1.0) (2015-10-12)

- [Changes](https://github.com/nvzqz/RandomKit/compare/v1.0.0...v1.1.0)
- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.1.0)

### New Features
- `RandomType` protocol for types that can generate a random value of `Self`.
- Added a `random` property to `CollectionType` that returns a random element of `self`, or `nil` if `self` is empty
- `String.RandomLength` for setting the default length used by `String.random()`

---

## [v1.0.0](https://github.com/nvzqz/RandomKit/tree/v1.0.0) (2015-10-11)

- [Release](https://github.com/nvzqz/RandomKit/releases/tag/v1.0.0)

Initial release
