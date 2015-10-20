//
//  NSURL+RandomKit.swift
//  RandomKit
//
//  Created by Nikolai Vazquez on 10/12/15.
//  Copyright © 2015 Nikolai Vazquez. All rights reserved.
//

import Foundation

private var _RandomValues = [
    "https://github.com/",
    "https://bitbucket.org/",
    "https://stackoverflow.com/",
    "https://www.reddit.com/",
    "https://medium.com/",
    "https://www.google.com/",
    "https://www.youtube.com/"
]

extension NSURL: RandomType {

    /// The default values from which a random URL is generated.
    public class var RandomValues: [String] {
        get { return _RandomValues     }
        set { _RandomValues = newValue }
    }

    /// Generates a random URL.
    ///
    /// - Returns: A random URL within `RandomValues`.
    public class func random() -> Self {
        return random(fromValues: RandomValues)
    }

    /// Generates a random URL from within the given values.
    ///
    /// If `values` is empty, a URL pointing to www.google.com is returned.
    ///
    /// - Parameters:
    ///     - values: The values from which the URL is generated.
    public class func random(fromValues values: [String]) -> Self {
        guard let value = values.random, url = self.init(string: value) else {
            return self.init(string: "https://www.google.com/")!
        }
        return url
    }

}
