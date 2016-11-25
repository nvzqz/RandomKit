//
//  Style.swift
//  RandomKit Benchmark
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

import RandomKit

enum Style: UInt8 {

    case bold = 1
    case underline = 4

    case black = 30, red, green, yellow, blue, magenta, cyan, white

}

private func style(_ string: String, with codes: [String]) -> String {
    if styleOutput {
        let csi = "\u{1B}["
        return csi + codes.joined(separator: ";") + "m" + string + csi + "0m"
    } else {
        return string
    }
}

private func style(_ string: String, with codes: [UInt8]) -> String {
    return style(string, with: codes.map(String.init(_:)))
}

func style(_ string: String, with styles: [Style]) -> String {
    return style(string, with: styles.map { $0.rawValue })
}

func style<T>(_ value: T, with styles: [Style] = [.bold, .magenta]) -> String {
    return style(String(describing: value), with: styles)
}

func style<T>(_ type: T.Type) -> String {
    return style(type, with: [.bold, .green])
}

func style(_ generator: RandomGenerator) -> String {
    return style(generator, with: [.yellow])
}

func style(count: Int) -> String {
    return style(count, with: [.bold, .blue])
}
