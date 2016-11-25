//
//  Help.swift
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

import Foundation

func printHelpAndExit() -> Never {
    var message = "RandomKit benchmark\n"
    message += "\n"
    message += "Flags:\n"
    message += "\n"
    message += "    --help                  Print this help message\n"
    message += "    --no-color              Output no color\n"
    message += "\n"
    message += "    --count, -c COUNT       The number of times to benchmark (default: 10000000)\n"
    message += "\n"
    message += "    --all, -a               Benchmark all of the following\n"
    message += "    --all-generators        Benchmark all generators\n"
    message += "    --all-integers          Benchmark all integer types\n"
    message += "    --all-protocols         Benchmark all protocols\n"
    message += "\n"
    message += "    --array COUNT           Benchmark both safe and unsafe random arrays\n"
    message += "                            Default count is 100\n"
    message += "    --array-safe COUNT      Benchmark safe random arrays\n"
    message += "                            Default count is 100\n"
    message += "    --array-unsafe COUNT    Benchmark unsafe random arrays\n"
    message += "                            Default count is 100\n"
    message += "\n"
    message += "Generators:\n"
    message += "\n"
    message += "    --xoroshiro             Use both safe and unsafe xoroshiro generators\n"
    message += "    --xoroshiro-safe        Use safe xoroshiro generator\n"
    message += "    --xoroshiro-unsafe      Use unsafe xoroshiro generator\n"
    message += "    --arc4random            Use arc4random generator\n"
    message += "    --dev                   Use both /dev/random and /dev/urandom generators\n"
    message += "    --dev-random            Use /dev/random generator\n"
    message += "    --dev-urandom           Use /dev/urandom generator\n"
    message += "\n"
    message += "Protocols: (passed as arguments)\n"
    message += "\n"
    message += "    Random\n"
    message += "    RandomToValue\n"
    message += "    RandomThroughValue\n"
    message += "    RandomWithinRange\n"
    print(message)
    exit(EXIT_SUCCESS)
}
