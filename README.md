[![RandomKit](https://github.com/nvzqz/RandomKit/raw/assets/banner.png)](https://github.com/nvzqz/RandomKit)

<p align="center">
<img src="https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos%20%7C%20linux-lightgrey.svg" alt="Platform">
<img src="https://img.shields.io/badge/language-swift-orange.svg" alt="Language: Swift">
<a href="https://cocoapods.org/pods/RandomKit"><img src="https://img.shields.io/cocoapods/v/RandomKit.svg" alt="CocoaPods - RandomKit"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage"></a>
<a href="https://gitter.im/nvzqz/RandomKit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://badges.gitter.im/Join%20Chat.svg" alt="GITTER: join chat"></a>
<a href="https://codebeat.co/projects/github-com-nvzqz-randomkit"><img src="https://codebeat.co/badges/256f6b2d-fd36-4b71-8bf0-b3cb31cb95ae" alt="codebeat badge"></a>
<img src="https://img.shields.io/badge/license-MIT-000000.svg" alt="License">
</p>

RandomKit is a Swift framework that makes random data generation simple and easy.

- [Installation](#installation)
    - [Compatibility](#compatibility)
    - [Swift Package Manager](#install-using-swift-package-manager)
    - [CocoaPods](#install-using-cocoapods)
    - [Carthage](#install-using-carthage)
- [Benchmark](#benchmark)
- [Usage](#usage)
    - [RandomGenerator](#randomgenerator)
    - [Protocols](#protocols)
        - [Random](#random)
        - [RandomWithinRange](#randomwithinrange)
        - [RandomWithinClosedRange](#randomwithinclosedrange)
        - [RandomToValue](#randomtovalue)
        - [RandomThroughValue](#randomthroughvalue)
        - [Shuffleable](#shuffleable)
    - [Swift Types](#swift-types)
        - [Integers](#integers)
        - [Floating Point Numbers](#floating-point-numbers)
        - [Bool](#bool)
        - [String, Character, and UnicodeScalar](#string-character-and-unicodescalar)
        - [Sequence and Collection](#sequence-and-collection)
        - [Arrays](#arrays)
    - [Foundation Types](#foundation-types)
        - [URL](#url)
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

## Installation

### Compatibility

- Platforms:
    - macOS 10.9+
    - iOS 8.0+
    - watchOS 2.0+
    - tvOS 9.0+
    - Linux
- Xcode 8.0
- Swift 3.0

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
                     majorVersion: 3)
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

    pod 'RandomKit', '~> 3.0.0'
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

The `RandomGenerator` enum is used by all `random-` methods and functions for
specifying the random generator to use.

**Available Generators:**

- `arc4random`

- `devRandom` (reads from "/dev/random")

- `devURandom` (reads from "/dev/urandom")

- `xoroshiro`

The default random generator is specified with `RandomGenerator.default` and can
be changed. It is initially `xoroshiro(threadSafe: true)`.

Because the `arc4random` family of functions isn't available on most Linux
distros, using this case will do nothing on Linux.

Although there are `randomize` methods publicly available, they're used
internally throughout the library.

### Protocols

RandomKit is very protocol-oriented, which gives it the ability to perform many
neat tasks.

#### Random

A protocol for types that can generate random values.

#### RandomWithinRange

A protocol for types that can generate optional random values within a range.

#### RandomWithinClosedRange

A protocol for types that can generate random values within a closed ranges.

```swift
Int.random(within: -100...100)       // -79
Character.random(within: "a"..."z")  // "f"
```

#### RandomToValue

A protocol for types that can generate random values from a base value to
another value, noninclusive.

The base value for integers is 0. This means that calling `random(to:)` on a
negative value will yield a random negative value or zero whereas a positive
value will yield a random positive value or zero.

If `value` == `randomBase`, `value` will be returned for `random(to:)`.

```swift
Int.random(to:  2)  // Either 0 or 1
Int.random(to:  0)  // Always 0
Int.random(to: 32)  // 15
Int.random(to: -5)  // -3
```

#### RandomThroughValue

A protocol for types that can generate random values from a base value through
another value, inclusive.

The same rules for the base value of `RandomToMax` apply to `RandomThroughMax`.

#### Shuffleable

A protocol for types whose elements can be shuffled.

```swift
// Array
[1, 2, 3, 4, 5].shuffled()  // [3, 4, 1, 5, 2]

// Dictionary
["a": 1, "b": 2, "c": 3].shuffled()  // ["a": 3, "b": 1, "c": 2]
```

The mutable counterpart of `shuffled()` is `shuffle()`.

### Swift Types

#### Integers

All of Swift's native integer types conform to the `Random-` protocols.

The `random()` and `random(using:)` functions create an integer of any value. As
a result, negative values can result for signed integers.

```swift
Int.random()                 // An Int within Int.min and Int.max
Int.random(within: 10...20)  // An Int within 10 and 20
```

To create a positive signed integer, use `random(to:)` or `random(through:)`.

```swift
Int.random(to: 1000)     // 731
Int.random(through: 10)  // 4
```

Signed integers can be created from any range, without danger of overflow.

```swift
Int.random(within: (.min + 1000)...(.max - 200))  // 5698527899712144154
```

#### Floating Point Numbers

Generate a random floating point value from within a range or `0.0...1.0` by
default.

```swift
Double.random()                   //  0.9813615573117475
Double.random(within:  -10...10)  // -4.03042337718197
Float.random(within:   -10...10)  //  5.167088
Float80.random(within: -10...10)  // -3.63204542399198874
```

All `FloatingPoint` types can also conform to `RandomWithinClosedRange`
out-of-the-box.

#### Bool

`Bool.random()` has a 50/50 chance of being `true` for the default generator.

#### String, Character, and UnicodeScalar

`String`, `Character`, and `UnicodeScalar` generate values within `" "..."~"` by
default.

```swift
String.random(ofLength: 10)                     // "}+[=Ng>$w1"
String.random(ofLength: 10, within: "A"..."z")  // "poUtXJIbv["

Character.random()                   // "#"
Character.random(within: "A"..."z")  // "s"
```

#### Sequence and Collection

All types that conform to `Sequence` and/or `Collection` have a `random`
property that returns a random element, or `nil` if the collection is empty.

```swift
["Bob", "Cindy", "May", "Charles", "Javier"].random  // "Charles"

"Hello".characters.random  // "e"
```

Even Foundation types that conform to either protocol get this property.

```swift
NSDictionary(dictionary: ["k1":"v1", "k2":"v2"]).random      // (k1, v1)

NSSet(array: ["First", "Second", "Third", "Fourth"]).random  // "Third"
```

#### Arrays

An array of random values can be generated for types conforming to `Random` using `init(randomCount:)`.

Similar initializers exist for `RandomWithinRange` and `RandomWithinClosedRange`.

```swift
let randoms = Array<Int>(randomCount: 100)  // [[8845477344689834233, -957454203475087100, ...]
```

For types conforming to `UnsafeRandom`, a faster alternative is `init(unsafeRandomCount:using:)`.
This initializer fills the buffer directly rather than using `random()`.

```swift
let unsafeRandoms = Array<Int>(unsafeRandomCount: 100)  // [759709806207883991, 4618491969012429761, ...]
```

A benchmark of generating 1000 random arrays of 10000 count:

| Generator                         | Safe (seconds)        | Unsafe (seconds)  |
| --------------------------------- | --------------------- | ----------------- |
| `xoroshiro(threadSafe: false)`    | 3.4709                | 0.1068            |
| `xoroshiro(threadSafe: true)`     | 3.9388                | 0.1059            |
| `arc4Random`                      | 6.6060                | 0.3336            |
| `dev(random)`                     | 67.7667               | 5.7254            |
| `dev(urandom)`                    | 71.0310               | 5.7347            |

### Foundation Types

#### URL

Generate a random `URL` from a list of values.

```swift
URL.random()  // https://medium.com/
              // https://stackoverflow.com/
              // https://github.com/
              // ...
```

#### Date

A random `Date` can be generated between two `Date` or `TimeInterval` values.

The default `random()` function returns a `Date` within `Date.distantPast` and
`Date.distantFuture`.

```swift
Date.random()  // "Aug 28, 2006, 3:38 AM"
Date.random(within: Date.distantPast...Date())  // "Feb 7, 472, 5:40 AM"
```

#### Decimal

The `Decimal` type conforms to `RandomWithinClosedRange`.

The `random()` function returns a `Decimal` between 0 and 1 by default.

```swift
Decimal.random()                    // 0.87490000409886706715888973957833129437
Decimal.random(within: 0.0...10.0)  // 6.5464639772070720738747790627821299859
```

#### NSNumber

A random number can be generated from within an integer or double range, or
`0...100` by default.

```swift
NSNumber.random()                   // 79
NSNumber.random(within: -50...100)  // -27
NSNumber.random(within: 0...200.0)  // 149.6156950363926
```

#### Cocoa and UIKit Types

##### NSColor and UIColor

A random color can be generated, with or without random alpha.

```swift
NSColor.random()            // r 0.694 g 0.506 b 0.309 a 1.0
NSColor.random(alpha: true) // r 0.859 g 0.57  b 0.409 a 0.047

UIColor.random()            // r 0.488 g 0.805 b 0.679 a 1.0
UIColor.random(alpha: true) // r 0.444 g 0.121 b 0.602 a 0.085
```

### CoreGraphics Types

#### CGFloat

Because `CGFloat` conforms to `FloatingPoint`, it conforms to
`RandomWithinClosedRange` just like how `Double` and `Float` do.

```swift
CGFloat.random()         // 0.699803650379181
CGFloat.random(0...100)  // 43.27969591675319
```

#### CGPoint

A random point can be generated from within ranges for x and y.

```swift
CGPoint.random()                         // {x 70.093 y 95.721}
CGPoint.random(within: 0...200, 0...10)  // {x 73.795 y 0.991}
```

#### CGSize

A random size can be generated from within ranges for width and height.

```swift
CGSize.random()                         // {w 3.744  h 35.932}
CGSize.random(within: 0...50, 0...400)  // {w 38.271 h 239.636}
```

#### CGRect

A random rectangle can be generated from within ranges for x, y, width, and
height.

```swift
CGRect.random()                                         // {x 3.872  y 46.15  w 8.852  h 20.201}
CGRect.random(within: 0...50, 0...100, 0...25, 0...10)  // {x 13.212 y 79.147 w 20.656 h 5.663}
```

#### CGVector

A random vector can be generated from  within ranges for dx and dy.

```swift
CGVector.random()                        // {dx 13.992 dy 89.376}
CGVector.random(within: 0...50, 0...10)  // {dx 35.224 dy 13.463}
```

## Extra

### [BigInt](https://github.com/lorentey/BigInt)

RandomKit extensions for Károly's [BigInt](https://github.com/lorentey/BigInt) library are available in [RandomKitBigInt](https://github.com/nvzqz/RandomKitBigInt).

## License

RandomKit and its assets are released under the [MIT License](LICENSE.md). Assets
can be found in the [`assets`](https://github.com/nvzqz/RandomKit/tree/assets)
branch.
