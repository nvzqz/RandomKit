[![RandomKit](https://github.com/nvzqz/RandomKit/raw/assets/banner.png)](https://github.com/nvzqz/RandomKit)

<p align="center">
<img src="https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos%20%7C%20linux-lightgrey.svg" alt="Platform">
<img src="https://img.shields.io/badge/language-swift-orange.svg" alt="Language: Swift">
<a href="https://cocoapods.org/pods/RandomKit"><img src="https://img.shields.io/cocoapods/v/RandomKit.svg" alt="CocoaPods - RandomKit"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage"></a>
<img src="https://img.shields.io/cocoapods/dt/RandomKit.svg" alt="downloads">
<a href="https://gitter.im/nvzqz/RandomKit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://badges.gitter.im/Join%20Chat.svg" alt="GITTER: join chat"></a>
<a href="https://codebeat.co/projects/github-com-nvzqz-randomkit"><img src="https://codebeat.co/badges/256f6b2d-fd36-4b71-8bf0-b3cb31cb95ae" alt="codebeat badge"></a>
<img src="https://img.shields.io/badge/license-MIT-000000.svg" alt="License">
<a href="https://nvzqz.github.io/RandomKit/docs/"><img alt="Documented" src="https://img.shields.io/badge/documented-%E2%9C%93-brightgreen.svg"></a>
</p>

RandomKit is a Swift framework that makes random data generation simple and easy.

- [Build Status](#build-status)
- [Installation](#installation)
    - [Compatibility](#compatibility)
    - [Swift Package Manager](#install-using-swift-package-manager)
    - [CocoaPods](#install-using-cocoapods)
    - [Carthage](#install-using-carthage)
- [Benchmark](#benchmark)
- [Usage](#usage)
    - [RandomGenerator](#randomgenerator)
    - [Thread Safety](#thread-safety)
    - [Protocols](#protocols)
        - [Random](#random)
        - [RandomInRange](#randominrange)
        - [RandomInClosedRange](#randominclosedrange)
        - [RandomToValue](#randomtovalue)
        - [RandomThroughValue](#randomthroughvalue)
        - [RandomRetrievable](#randomretrievable)
        - [RandomRetrievableInRange](#randomretrievableinrange)
        - [Shuffleable](#shuffleable)
        - [UniqueShuffleable](#uniqueshuffleable)
    - [Swift Types](#swift-types)
        - [Integers](#integers)
        - [Floating Point Numbers](#floating-point-numbers)
        - [Bool](#bool)
        - [String, Character, and UnicodeScalar](#string-character-and-unicodescalar)
        - [Arrays](#arrays)
        - [Arrays Benchmark](#arrays-benchmark)
    - [Foundation Types](#foundation-types)
        - [Date](#date)
        - [Decimal](#decimal)
        - [NSNumber](#nsnumber)
        - [Cocoa and UIKit Types](#cocoa-and-uikit-types)
            - [NSColor and UIColor](#nscolor-and-uicolor)
    - [CoreGraphics Types](#coregraphics-types)
        - [CGFloat](#cgfloat)
        - [CGPoint](#cgpoint)
        - [CGSize](#cgsize)
        - [CGRect](#cgrect)
        - [CGVector](#cgvector)
- [Extra](#extra)
    - [BigInt](#bigint)
- [License](#license)

## Build Status

| Branch    | Status |
| :-------: | :----: |
| `master`  | [![Build Status](https://travis-ci.org/nvzqz/RandomKit.svg?branch=master)](https://travis-ci.org/nvzqz/RandomKit) |

## Installation

### Compatibility

- Platforms:
    - macOS 10.9+
    - iOS 8.0+
    - watchOS 2.0+
    - tvOS 9.0+
    - Linux
- Xcode 8.0+
- Swift 3.0.2+ & 4.0

RandomKit is possibly also compatible with FreeBSD, Android, and Windows
(under Cygwin) but has not been tested for those platforms.

### Install Using Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a
decentralized dependency manager for Swift.

1. Add the project to your `Package.swift`.

    ```swift
    import PackageDescription

    let package = Package(
        name: "MyAwesomeProject",
        dependencies: [
            .Package(url: "https://github.com/nvzqz/RandomKit.git",
                     majorVersion: 5)
        ]
    )
    ```

2. Import the RandomKit module.

    ```swift
    import RandomKit
    ```

### Install Using CocoaPods
[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for
Objective-C and Swift. Go [here](https://guides.cocoapods.org/using/index.html)
to learn more.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!

    pod 'RandomKit', '~> 5.2.2'
    ```

    If you want to be on the bleeding edge, replace the last line with:

    ```ruby
    pod 'RandomKit', :git => 'https://github.com/nvzqz/RandomKit.git'
    ```

2. Run `pod install` and open the `.xcworkspace` file to launch Xcode.

3. Import the RandomKit framework.

    ```swift
    import RandomKit
    ```

### Install Using Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency
manager for Objective-C and Swift.

1. Add the project to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

    ```
    github "nvzqz/RandomKit"
    ```

2. Run `carthage update` and follow [the additional steps](https://github.com/Carthage/Carthage#getting-started)
   in order to add RandomKit to your project.

3. Import the RandomKit framework.

    ```swift
    import RandomKit
    ```

## Benchmark

Various components of RandomKit can be easily benchmarked by running `benchmark.sh`.

```shell
./benchmark.sh [FLAGS] [PROTOCOLS]
```

Use the `--help` flag for information regarding how to use it.

**Note:** The default count is 10000000, which is A LOT if using the `--array` flag.
This can be changed by passing an argument into `--count` or `-c`.

## Usage

Try it out for yourself! Download the repo and open 'RandomKit.playground'.

### RandomGenerator

The `RandomGenerator` protocol defines basic methods for generating primitive
values and randomizing a buffer.

All provided types that conform to `RandomGenerator` have a static `default`
value that can be passed as an `inout` argument to generation functions.

```swift
let value = Int.random(using: &Xoroshiro.default)
```

#### Available Generators

- `ARC4Random`
    - Because the symbols for the `arc4random` family of functions aren't
      exported with Foundation on Linux and other platforms, they're dynamically
      loaded at runtime.

- `DeviceRandom`
    - Reads from "/dev/random" or "/dev/urandom" as its source.

- `MersenneTwister`

- `Xoroshiro`

- `Xorshift`

- `XorshiftStar`

- `ChaCha`

#### SeedableRandomGenerator

`SeedableRandomGenerator` is for types that can be seeded with some associated
`Seed` type.

#### RandomBytesGenerator

The `RandomBytesGenerator` protocol is for types that specialize in generating a
specific type that fills up a number of bytes. For example, `MersenneTwister`
specializes in generating `UInt64` while `Xorshift` generates `UInt32` values.

### Thread Safety

For single-threaded programs, it is safe to use a global generator instance such
as `Xoroshiro.default` as a source of randomness.

For multi-threaded programs, the thread-local instances should be used. This
allows for different threads to use their own separate random generators without
a shared mutable state.

In the following example, `randomGenerator` is unique to each thread.

```swift
let randomBytes = Xoroshiro.withThreadLocal { randomGenerator in
    return [UInt8](randomCount: 1000, using: &randomGenerator)
}
```

Thread-local generators are deallocated upon thread exit, so there's no need to
worry about cleanup.

It's recommended to not call `withThreadLocal(_:)` or get the `threadLocal`
pointer each individual time it's needed. Retrieving the thread-local instance
incurs avoidable overhead.

```swift
// Bad
let value = Int.random(using: &Xoroshiro.threadLocal.pointee)
array.shuffle(using: &Xoroshiro.threadLocal.pointee)

// Good
let threadLocal = Xoroshiro.threadLocal
let value = Int.random(using: &threadLocal.pointee)
array.shuffle(using: &threadLocal.pointee)

// Better
Xoroshiro.withThreadLocal { randomGenerator in
    let value = Int.random(using: &randomGenerator)
    array.shuffle(using: &randomGenerator)
}
```

As a shortcut, you can even apply a function directly as a parameter.

```swift
let value = Xoroshiro.withThreadLocal(Int.random)
```

Prior to [v4.4.0](https://github.com/nvzqz/RandomKit/releases/tag/v4.4.0),
thread safety could be achieved by instantiating a new seeded instance of a
given `RandomGenerator` type. The problem with this is that unnecessary seeding
occurs each time. With this, the generator is seeded once and can then be reused
at later points.

Shortcuts to the reseeding version of a generator are also available:
```swift
Xoroshiro.withThreadLocalReseeding {
    ...
}
```

Which is *way* better than writing:
```swift
ReseedingRandomGenerator.withThreadLocal(createdWith: { Xoroshiro.reseeding }) {
    ...
}
```

### Protocols

RandomKit is very protocol-oriented, which gives it the ability to be very
flexible and modular.

#### Random

A protocol for types that can generate random values using a `RandomGenerator`.

#### RandomInRange

A protocol for types that can generate optional random values within a range
using a `RandomGenerator`.

```swift
Int.random(in: 0 ..< 0, using: &randomGenerator) // nil
```

#### RandomInClosedRange

A protocol for types that can generate random values within a closed range
using a `RandomGenerator`.

```swift
Int.random(in: -100 ... 100, using: &randomGenerator) // -79
```

#### RandomToValue

A protocol for types that can generate random values from a base value to
another value, noninclusive.

The base value for integers is 0. This means that calling `random(to:using:)` on
a negative value will yield a random negative value or zero whereas a positive
value will yield a random positive value or zero.

If `value` == `randomBase`, `value` will be returned for `random(to:using:)`.

```swift
Int.random(to:  2, using: &randomGenerator)  // Either 0 or 1
Int.random(to:  0, using: &randomGenerator)  // Always 0
Int.random(to: 32, using: &randomGenerator)  // 15
Int.random(to: -5, using: &randomGenerator)  // -3
```

#### RandomThroughValue

A protocol for types that can generate random values from a base value through
another value, inclusive.

The same rules regarding the base value of `RandomToValue` apply to
`RandomThroughValue`.

#### RandomRetrievable

A protocol for types whose instances can have random elements retrieved.

```swift
["Bob", "Cindy", "May", "Charles", "Javier"].random(using: &randomGenerator)  // "Charles"

"Hello".characters.random(using: &randomGenerator)  // "e"
```

Some Foundation types like `NSArray` conform to this protocol.

#### RandomRetrievableInRange

A protocol for types whose instances can have random elements retrieved from
within a `Range<Index>`.

```swift
[20, 37, 42].random(in: 1 ..< 3, using: &randomGenerator)  // Either 37 or 42
```

#### Shuffleable

A protocol for types whose elements can be shuffled.

```swift
// Array
[1, 2, 3, 4, 5].shuffled(using: &randomGenerator)  // [3, 4, 1, 5, 2]

// Dictionary
["a": 1, "b": 2, "c": 3].shuffled(using: &randomGenerator)  // ["a": 3, "b": 1, "c": 2]
```

The mutable counterpart of `shuffled(using:)` is `shuffle(using:)`.

For better `Array` shuffling performance, consider shuffling in-place with
`shuffle(using:)`.

#### UniqueShuffleable

Similar to `Shuffleable`, except no element is ever in its initial position.

### Swift Types

#### Integers

All of Swift's native integer types conform to the `Random-` protocols.

The `random(using:)` function creates an integer of any value. As a result,
negative values can result for signed integers.

```swift
Int.random(using: &randomGenerator)               // An Int within Int.min and Int.max
Int.random(in: 10...20, using: &randomGenerator)  // An Int within 10 and 20
```

To create a positive signed integer, use `random(to:using:)` or `random(through:using:)`.

```swift
Int.random(to: 1000, using: &randomGenerator)     // 731
Int.random(through: 10, using: &randomGenerator)  // 4
```

Signed integers can be created from any range, without danger of overflow.

```swift
Int.random(in: (.min + 1000)...(.max - 200), using: &randomGenerator)  // 5698527899712144154
```

#### Floating Point Numbers

Generate a random floating point value from within a range or `0.0...1.0` by
default.

```swift
Double.random(using: &randomGenerator)                 //  0.9813615573117475
Double.random(in:  -10...10, using: &randomGenerator)  // -4.03042337718197
Float.random(in:   -10...10, using: &randomGenerator)  //  5.167088
Float80.random(in: -10...10, using: &randomGenerator)  // -3.63204542399198874
```

All `FloatingPoint` types can also conform to `RandomInClosedRange`
out-of-the-box.

#### Bool

`Bool.random(using:)` has a 50/50 chance of being `true`.

If you need different probability, there's also `random(withWeight:using:)`,
which has 1 in `weight` chance of being `true`.

#### String, Character, and UnicodeScalar

`String`, `Character`, and `UnicodeScalar` generate values within `" "..."~"` by
default.

```swift
String.random(ofLength: 10, using: &randomGenerator)                 // "}+[=Ng>$w1"
String.random(ofLength: 10, in: "A"..."z", using: &randomGenerator)  // "poUtXJIbv["

Character.random(using: &randomGenerator)                 // "#"
Character.random(in: "A"..."z", using: &randomGenerator)  // "s"
```

#### Arrays

An array of random values can be generated for types conforming to `Random` with
`init(randomCount:using:)`.

Similar initializers exist for all other `Random-` protocols.

```swift
let randoms = Array<Int>(randomCount: 100, using: &randomGenerator)  // [8845477344689834233, -957454203475087100, ...]
```

For types conforming to `UnsafeRandom`, a faster alternative is `init(unsafeRandomCount:using:)`.
This initializer fills the buffer directly rather than using `random(using:)`.

```swift
let unsafeRandoms = Array<Int>(unsafeRandomCount: 100, using: &randomGenerator)  // [759709806207883991, 4618491969012429761, ...]
```

##### Arrays Benchmark

A benchmark of generating 1000 random `Int` arrays of 10000 count:

| Generator                 | Time (in seconds) |
| ------------------------- | ----------------- |
| `Xoroshiro`               | 0.0271            |
| `Xorshift`                | 0.0568            |
| `XorshiftStar`            | 0.0319            |
| `ChaCha`                  | 0.2027            |
| `MersenneTwister`         | 0.0432            |
| `ARC4Random`              | 0.2416            |
| `DeviceRandom`            | 5.3348            |

**Note:** Results may vary due to various factors.

This same benchmark can be run with:

```shell
./benchmark.sh --all-generators --array 10000 --count 1000
```

### Foundation Types

#### Date

A random `Date` can be generated between two `Date` or `TimeInterval` values.

The default `random(using:)` function returns a `Date` within `Date.distantPast` and
`Date.distantFuture`.

```swift
Date.random(using: &randomGenerator)  // "Aug 28, 2006, 3:38 AM"
Date.random(in: Date.distantPast...Date(), using: &randomGenerator)  // "Feb 7, 472, 5:40 AM"
```

#### Decimal

The `Decimal` type conforms to various `Random-` protocols.

The `random(using:)` function returns a `Decimal` between 0 and 1 by default.

```swift
Decimal.random(using: &randomGenerator)                  // 0.87490000409886706715888973957833129437
Decimal.random(in: 0.0...10.0, using: &randomGenerator)  // 6.5464639772070720738747790627821299859
```

#### NSNumber

A random number can be generated from within an integer or double range, or
`0...100` by default.

```swift
NSNumber.random(using: &randomGenerator)                 // 79
NSNumber.random(in: -50...100, using: &randomGenerator)  // -27
NSNumber.random(in: 100...200, using: &randomGenerator)  // 149.6156950363926
```

#### Cocoa and UIKit Types

##### NSColor and UIColor

A random color can be generated, with or without random alpha.

```swift
NSColor.random(using: &randomGenerator)              // r 0.694 g 0.506 b 0.309 a 1.0
NSColor.random(alpha: true, using: &randomGenerator) // r 0.859 g 0.57  b 0.409 a 0.047

UIColor.random(using: &randomGenerator)              // r 0.488 g 0.805 b 0.679 a 1.0
UIColor.random(alpha: true, using: &randomGenerator) // r 0.444 g 0.121 b 0.602 a 0.085
```

### CoreGraphics Types

#### CGFloat

Because `CGFloat` conforms to `FloatingPoint`, it conforms to
`RandomInClosedRange` just like how `Double` and `Float` do.

```swift
CGFloat.random(using: &randomGenerator)               // 0.699803650379181
CGFloat.random(in: 0...100, using: &randomGenerator)  // 43.27969591675319
```

#### CGPoint

A random point can be generated from within ranges for x and y.

```swift
CGPoint.random(using: &randomGenerator) // {x 70.093 y 95.721}
CGPoint.random(xRange: 0...200, yRange: 0...10, using: &randomGenerator) // {x 73.795 y 0.991}
```

#### CGSize

A random size can be generated from within ranges for width and height.

```swift
CGSize.random(using: &randomGenerator) // {w 3.744  h 35.932}
CGSize.random(widthRange: 0...50, heightRange: 0...400, using: &randomGenerator) // {w 38.271 h 239.636}
```

#### CGRect

A random rectangle can be generated from within ranges for x, y, width, and
height.

```swift
CGRect.random(using: &randomGenerator)  // {x 3.872  y 46.15  w 8.852  h 20.201}
CGRect.random(xRange: 0...50,
              yRange: 0...100,
              widthRange: 0...25,
              heightRange: 0...10,
              using: &randomGenerator)  // {x 13.212 y 79.147 w 20.656 h 5.663}
```

#### CGVector

A random vector can be generated from within ranges for dx and dy.

```swift
CGVector.random(using: &randomGenerator) // {dx 13.992 dy 89.376}
CGVector.random(dxRange: 0...50, dyRange: 0...10, using: &randomGenerator) // {dx 35.224 dy 13.463}
```

## Extra

### [BigInt](https://github.com/lorentey/BigInt)

RandomKit extensions for Károly's [BigInt](https://github.com/lorentey/BigInt) library are available in [RandomKitBigInt](https://github.com/nvzqz/RandomKitBigInt).

## License

RandomKit and its assets are released under the [MIT License](LICENSE.md). Assets
can be found in the [`assets`](https://github.com/nvzqz/RandomKit/tree/assets)
branch.

Parts of this project utilize code written by [Matt Gallagher](https://github.com/mattgallagher) and, in conjunction
with the MIT License, are licensed with that found [here](https://www.cocoawithlove.com/about/).
