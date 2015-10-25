//
//  NSURL+RandomKit.swift
//  RandomKit
//
//  Created by Nikolai Vazquez on 10/12/15.
//  Copyright © 2015 Nikolai Vazquez. All rights reserved.
//

import Foundation

extension NSURL: RandomType {

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
    public class func random() -> Self {
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
    public class func random(fromValues values: [String]) -> Self {
        guard let value = values.random, url = self.init(string: value) else {
            return self.init(string: "https://www.google.com/")!
        }
        return url
    }

}
