//
//  NSURL+RandomKit.swift
//  RandomKit
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

import Foundation

extension URL: RandomType {

    /// Generates a random URL.
    ///
    /// - Returns: A random URL within:
    ///     - https://github.com/
    ///     - https://bitbucket.org/
    ///     - https://stackoverflow.com/
    ///     - https://www.reddit.com/
    ///     - https://medium.com/
    ///     - https://www.google.com/
    ///     - https://www.youtube.com/
    public static func random() -> URL {
        return random(fromValues: [
            "https://github.com/",
            "https://bitbucket.org/",
            "https://stackoverflow.com/",
            "https://www.reddit.com/",
            "https://medium.com/",
            "https://www.google.com/",
            "https://www.youtube.com/"
        ])
    }

    /// Generates a random URL from within the given values.
    ///
    /// If `values` is empty, a URL pointing to www.google.com is returned.
    ///
    /// - Parameters:
    ///     - values: The values from which the URL is generated.
    public static func random(fromValues values: [String]) -> URL {
        guard let value = values.random, let url = self.init(string: value) else {
            return self.init(string: "https://www.google.com/")!
        }
        return url
    }

}
