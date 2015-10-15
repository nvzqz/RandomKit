# RandomKit ![Platform](https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20watchos-lightgrey.svg) [![RandomKit](https://img.shields.io/cocoapods/v/RandomKit.svg)](https://cocoapods.org/pods/RandomKit) [![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Random data generation in Swift.

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

    pod 'RandomKit', '~> 1.3.0'
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

### `Int`

```swift
Int.random()        // An Int within 0 and 100
Int.random(10...20) // An Int within 10 and 20
```

### `Double`, `Float`, and `CGFloat`

```swift
Double.random(-10...10) // -4.03042337718197
Float.random(-10...10)  //  5.167088
CGFloat.random()        //  0.699803650379181
```

### `Bool`
`Bool.random()` has a 50/50 chance of being `true`.

### `String` and `Character`

```swift
String.random(10) // "}+[=Ng>$w1"
String.random(10, "A"..."z") // "poUtXJIbv["
String.random(10, .uppercaseLetterCharacterSet()) // ṤՈ𝕮𝝘ꝻṄԱＭĐŦ

Character.random() // "#"
Character.random("A"..."z") // "s"
Character.random(.uppercaseLetterCharacterSet()) // "𝝙"
```

### `CollectionType`

All types that conform to `CollectionType` have a `random` property
that returns a random element, or `nil` if the collection is empty.

```swift
["Bob", "Cindy", "May", "Charles", "Javier"].random  // "Charles"
```

### `NSColor` and `UIColor`

```swift
NSColor.random()     // r 0.694 g 0.506 b 0.309 a 1.0
NSColor.random(true) // r 0.859 g 0.57  b 0.409 a 0.047

UIColor.random()     // r 0.488 g 0.805 b 0.679 a 1.0
UIColor.random(true) // r 0.444 g 0.121 b 0.602 a 0.085
```

## License

RandomKit and its assets are released under the [MIT License](LICENSE.md). Assets
can be found in the [`assets`](https://github.com/nvzqz/RandomKit/tree/assets)
branch.
