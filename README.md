<p align="center">
    <img src="https://github.com/nvzqz/RandomKit/raw/assets/banner.png" alt="RandomKit">
</p>

<p align="center">
    <img src="https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20watchos-lightgrey.svg"
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
    - Version:  **7.0**
    - Language: **Swift 2.0**
- OS X
    - Compatible With:   **OS X 10.11**
    - Deployment Target: **OS X 10.9**
- iOS
    - Compatible With:   **iOS 9.0**
    - Deployment Target: **iOS 8.0**
- watchOS
    - Compatible With:   **watchOS 2.0**
    - Deployment Target: **watchOS 2.0**

### Install Using CocoaPods
[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for
Objective-C and Swift. Go [here](https://guides.cocoapods.org/using/index.html)
to learn more.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!

    pod 'RandomKit', '~> 1.4.0'
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

### `Int`

Generate a random `Int` from within an interval or `0...100` by default.

```swift
Int.random()        // An Int within 0 and 100
Int.random(10...20) // An Int within 10 and 20
```

### `Double`, `Float`, and `CGFloat`

Generate a random floating point value from within an interval or `0.0...1.0` by
default.

```swift
Double.random(-10...10) // -4.03042337718197
Float.random(-10...10)  //  5.167088
CGFloat.random()        //  0.699803650379181
```

### `Bool` and `Bit`

`Bool.random()` and `Bit.random()` have a 50/50 chance of being `true` and `One`
respectively.

### `String` and `Character`

Generate a random `String` or `Character` from within a `Character` interval or
from an `NSCharacterSet`.

```swift
String.random(10) // Default: " "..."~" -> "}+[=Ng>$w1"
String.random(10, "A"..."z") // "poUtXJIbv["
String.random(10, .uppercaseLetterCharacterSet()) // ṤՈ𝕮𝝘ꝻṄԱＭĐŦ

Character.random() // "#"
Character.random("A"..."z") // "s"
Character.random(.uppercaseLetterCharacterSet()) // "𝝙"
```

The default random `String` length can be changed by altering `String.RandomLength`.

### `SequenceType` and `CollectionType`

All types that conform to `SequenceType` and/or `CollectionType` have a `random`
property that returns a random element, or `nil` if the collection is empty.

```swift
["Bob", "Cindy", "May", "Charles", "Javier"].random  // "Charles"
```

### `NSURL`

Generate a random NSURL from a list of values.

```swift
NSURL.random()  // https://medium.com/
                // https://stackoverflow.com/
                // https://github.com/
                // ...
```

You can change the possible values yourself by altering `NSURL.RandomValues`.

### `NSDate`

Generate a random date between two `NSTimeInterval` values, or between `0.0` and `NSTimeInterval(UInt32.max)`.

```swift
NSDate.random()  // "Aug 28, 2006, 3:38 AM"
```

### `NSColor` and `UIColor`

Generate a random color with or without the alpha being random as well.

```swift
NSColor.random()            // r 0.694 g 0.506 b 0.309 a 1.0
NSColor.random(alpha: true) // r 0.859 g 0.57  b 0.409 a 0.047

UIColor.random()            // r 0.488 g 0.805 b 0.679 a 1.0
UIColor.random(alpha: true) // r 0.444 g 0.121 b 0.602 a 0.085
```

## License

RandomKit and its assets are released under the [MIT License](LICENSE.md). Assets
can be found in the [`assets`](https://github.com/nvzqz/RandomKit/tree/assets)
branch.
