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

extension NSURL {

    /// The default values from which a random `NSURL` is generated.
    public static var RandomValues: [String] {
        get { return _RandomValues     }
        set { _RandomValues = newValue }
    }

    /// Generates a random `NSURL` from within the given values.
    ///
    /// - Parameters:
    ///     - values: The values from which the URL is generated.
    ///       Default value is `RandomValues`.
    public class func random(fromValues values: [String] = RandomValues) -> NSURL? {
        guard let value = values.random else {
            return NSURL()
        }
        return NSURL(string: value)
    }

}
