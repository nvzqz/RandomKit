<p align="center">
    <img src="https://github.com/nvzqz/RandomKit/raw/assets/banner.png" alt="RandomKit">
</p>

<p align="center">
    <img src="https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20watchos%20%7C%20tvos-lightgrey.svg"
         alt="Platform">
    <img src="https://img.shields.io/badge/language-swift-orange.svg"
         alt="Language: Swift">
    <a href="https://cocoapods.org/pods/RandomKit">
        <img src="https://img.shields.io/cocoapods/v/RandomKit.svg"
             alt="CocoaPods - RandomKit">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"
             alt="Carthage">
    </a>
    <a href="https://gitter.im/nvzqz/RandomKit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
        <img src="https://img.shields.io/badge/GITTER-join%20chat-00D06F.svg"
             alt="GITTER: join chat">
    </a>
    <img src="https://img.shields.io/badge/license-MIT-000000.svg"
         alt="License">
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#license">License</a>
</p>

RandomKit is a Swift framework that makes random data generation simple and easy.

## Installation

### Compatibility

- Xcode
    - Version:  **8.0**
    - Language: **Swift 3.0**
- OS X
    - Compatible With:   **OS X 10.11**
    - Deployment Target: **OS X 10.9**
- iOS
    - Compatible With:   **iOS 9.1**
    - Deployment Target: **iOS 8.0**
- watchOS
    - Compatible With:   **watchOS 2.0**
    - Deployment Target: **watchOS 2.0**
- tvOS
    - Compatible With:   **tvOS 9.0**
    - Deployment Target: **tvOS 9.0**

### Install Using CocoaPods
[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for
Objective-C and Swift. Go [here](https://guides.cocoapods.org/using/index.html)
to learn more.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!

    pod 'RandomKit', '~> 1.6.0'
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

## Usage

Try it out for yourself! Download the repo and open 'RandomKit.playground'.

### Fake Random Data

Fake data can be generated from static methods found in `Random`.

#### Gender

Generate a random gender with a 50/50 chance of being "Male" or "Female".

```swift
Random.fakeGender()
```

#### Phone Number

Generate a random phone number for a given US state.

```swift
Random.fakePhoneNumber()          // 5808680873
Random.fakePhoneNumber(.Florida)  // 7865276359
```

The default value for state is `._Any`.

#### English Honorific

Generate a random English honorific for a given type and gender.

```swift
Random.fakeEnglishHonorific()                              // "Prof."
Random.fakeEnglishHonorific(type: .Professional)           // "Dr."
Random.fakeEnglishHonorific(type: .Common, gender: .Male)  // "Mr."
Random.fakeEnglishHonorific(gender: .Female)               // "Lady"
```

The default values for type and gender are `._Any` and `.Either` respectively.

### Protocols

#### RandomType

A protocol for types that can generate random values.

##### `randomGenerator()`

Returns a generator for infinite random values of `Self`.

```swift
let generator = Int.randomGenerator()
while let val = generator.next() {
    print(val)  // 62
}               // 66
                // 45...
```

##### `randomGenerator(maxCount:)`

Returns a generator for random values of `Self` within `maxCount`.

```swift
let generator = Int.randomGenerator(maxCount: 2)
while let val = generator.next() {
    print(val)  // 45
}               // 79
```

##### `randomSequence()`

Returns a sequence of infinite random values of `Self`.

```swift
for val in Int.randomSequence() {
    print(val)  // 10
}               // 83
                // 47...
```

##### `randomSequence(maxCount:)`

Returns a sequence of random values of `Self` within `maxCount`.

```swift
for val in Int.randomSequence(maxCount: 2) {
    print(val)  // 8
}               // 56
```

##### `Array(randomCount:)`

Creates an Array of random elements within `randomCount`.

```swift
[Int](randomCount: 7)     // [3, 55, 100, 50, 77, 23, 49]
[String](randomCount: 2)  // [";qYFOH10no", "V,Q[+koi>n"]
```

##### `Dictionary(randomCount:)`

Creates a Dictionary of random key-value pairs within `randomCount`.

```swift
[Int : Int](randomCount: 3)  // [43: 45, 56: 16, 44: 89]
```

##### `Set(randomCount:)`

Creates a Set of random elements within `randomCount`.

```swift
Set<Int>(randomCount: 5)  // {15, 78, 68, 77, 40}
```

###### Warning:

The `randomCount` parameter must be less than or equal to the total number of possible
values that the given `RandomType` can produce. Otherwise, the initializer will
never finish.

An example of this is using `Bool` with a `randomCount` greater than 2.

#### RandomIntervalType

A protocol for types that can generate random values within a closed interval.

```swift
Int.random(-100...100)       // -79
Character.random("a"..."z")  // "f"
```

There are also random generators and random sequences available to
`RandomIntervalType` that can be made for values within an interval.

#### ShuffleType

A protocol for types whose elements can be shuffled.

```swift
// Array
[1, 2, 3, 4, 5].shuffle()  // [3, 4, 1, 5, 2]

// Dictionary
["a": 1, "b": 2, "c": 3].shuffle()  // ["a": 3, "b": 1, "c": 2]
```

There is also the `shuffleInPlace()` method that shuffles the values in `self`
rather than return the shuffled result.

### Swift Types

#### Int

Generate a random `Int` from within an interval or `0...100` by default.

```swift
Int.random()        // An Int within 0 and 100
Int.random(10...20) // An Int within 10 and 20
```

#### Double, Float, and Float80

Generate a random floating point value from within an interval or `0.0...1.0` by
default.

```swift
Double.random(-10...10)  // -4.03042337718197
Float.random(-10...10)   //  5.167088
Float80.random(-10...10) // -3.63204542399198874
```

#### Bool

`Bool.random()` has a 50/50 chance of being `true`.

#### String and Character

Generate a random `String` or `Character` from within a `Character` interval or
`" "..."~"` by default.

```swift
String.random(10)            // "}+[=Ng>$w1"
String.random(10, "A"..."z") // "poUtXJIbv["

Character.random()           // "#"
Character.random("A"..."z")  // "s"
```

A random `String` or `Character` can also be generated from an `NSCharacterSet`.

```swift
String.random(10, .uppercaseLetterCharacterSet()) // "ṤՈ𝕮𝝘ꝻṄԱＭĐŦ"

Character.random(.uppercaseLetterCharacterSet())  // "𝝙"
```

#### Sequence and Collection

All types that conform to `Sequence` and/or `Collection` have a `random`
property that returns a random element, or `nil` if the collection is empty.

```swift
["Bob", "Cindy", "May", "Charles", "Javier"].random  // "Charles"

"Hello".characters.random  // "e"
```

Even Objective-C types that conform to either protocol get this property.

```swift
NSDictionary(dictionary: ["k1":"v1", "k2":"v2"]).random      // (k1, v1)

NSSet(array: ["First", "Second", "Third", "Fourth"]).random  // "Third"
```

### Objective-C Types

#### URL

Generate a random `URL` from a list of values.

```swift
URL.random()  // https://medium.com/
              // https://stackoverflow.com/
              // https://github.com/
              // ...
```

#### Date

Generate a random date between two `TimeInterval` values, or between `0.0` and
`TimeInterval(UInt32.max)`.

```swift
Date.random()  // "Aug 28, 2006, 3:38 AM"
```

#### NSColor and UIColor

Generate a random color with or without the alpha being random as well.

```swift
NSColor.random()            // r 0.694 g 0.506 b 0.309 a 1.0
NSColor.random(alpha: true) // r 0.859 g 0.57  b 0.409 a 0.047

UIColor.random()            // r 0.488 g 0.805 b 0.679 a 1.0
UIColor.random(alpha: true) // r 0.444 g 0.121 b 0.602 a 0.085
```

#### NSNumber

Generate a random number from within an integer or double interval, or `0...100` by default.

```swift
NSNumber.random()           // 79
NSNumber.random(-50...100)  // -27
NSNumber.random(0...200.0)  // 149.6156950363926
```

#### CharacterSet

Get a random character from a character set.

```swift
CharacterSet.uppercaseLetterCharacterSet().randomCharacter // "Ǩ"
```

#### CoreGraphics Types

##### CGFloat

Generate a random float like how you would with Double.random() or Float.random(). The default interval is `0.0...1.0`.

```swift
CGFloat.random()         // 0.699803650379181
CGFloat.random(0...100)  // 43.27969591675319
```

##### CGPoint

Generate a random point from within intervals for x and y.

```swift
CGPoint.random()                 // {x 70.093 y 95.721}
CGPoint.random(0...200, 0...10)  // {x 73.795 y 0.991}
```

##### CGSize

Generate a random size from within intervals for width and height.

```swift
CGSize.random()                 // {w 3.744  h 35.932}
CGSize.random(0...50, 0...400)  // {w 38.271 h 239.636}
```

##### CGRect

Generate a random rectangle from within intervals for x, y, width, and height.

```swift
CGRect.random()                                 // {x 3.872  y 46.15  w 8.852  h 20.201}
CGRect.random(0...50, 0...100, 0...25, 0...10)  // {x 13.212 y 79.147 w 20.656 h 5.663}
```

##### CGVector

Generate a random vector from within intervals for dx and dy.

```swift
CGVector.random()                // {dx 13.992 dy 89.376}
CGVector.random(0...50, 0...10)  // {dx 35.224 dy 13.463}
```

## License

RandomKit and its assets are released under the [MIT License](LICENSE.md). Assets
can be found in the [`assets`](https://github.com/nvzqz/RandomKit/tree/assets)
branch.
