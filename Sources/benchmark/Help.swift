//
//  Help.swift
//  RandomKit Benchmark
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2017 Nikolai Vazquez
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

private func sf(_ flag: String) -> String {
    return style(flag, with: [.blue])
}

private func sa(_ arg: String) -> String {
    return style(arg, with: [.bold, .yellow])
}

private func sp(_ proto: String) -> String {
    return style(proto, with: [.red])
}

private func ss(_ section: String) -> String {
    return style(section, with: [.underline])
}

func printHelpAndExit() -> Never {
    var message = ""
    message += ss("Usage:") + "\n"
    message += "\n"
    message += "    " + style("benchmark", with: [.green]) + " " + sf("[FLAGS]") + " " + sp("[PROTOCOLS]") + "\n"
    message += "\n"
    message += ss("Flags:") + "\n"
    message += "\n"
    message += "    " + sf("--help, -h") + "                  Print this help message\n"
    message += "    " + sf("--no-color") + "                  Output no color\n"
    message += "\n"
    message += "    " + sf("--count, -c") + " " + sa("COUNT") + "           The number of times to benchmark (default: 10000000)\n"
    message += "\n"
    message += "    " + sf("--all, -a") + "                   Benchmark all of the following\n"
    message += "    " + sf("--all-generators") + "            Benchmark all generators\n"
    message += "    " + sf("--all-integers") + "              Benchmark all integer types\n"
    message += "    " + sf("--all-protocols") + "             Benchmark all protocols\n"
    message += "\n"
    message += "    " + sf("--array") + " " + sa("COUNT") + "               Benchmark both safe and unsafe random arrays; default count is 100\n"
    message += "    " + sf("--array-safe") + " " + sa("COUNT") + "          Benchmark safe random arrays; default count is 100\n"
    message += "    " + sf("--array-unsafe") + " " + sa("COUNT") + "        Benchmark unsafe random arrays; default count is 100\n"
    message += "\n"
    message += ss("Generators:") + "\n"
    message += "\n"
    message += "    " + sf("--xoroshiro") + "                 Use both safe and unsafe xoroshiro generators\n"
    message += "    " + sf("--mersenne-twister") + "          Use both safe and unsafe mersenne twister generators\n"
    message += "    " + sf("--arc4random") + "                Use arc4random generator\n"
    message += "    " + sf("--dev") + "                       Use both /dev/random and /dev/urandom generators\n"
    message += "\n"
    message += ss("Protocols:") + " (passed as arguments)\n"
    message += "\n"
    message += "    " + sp("Random") + "\n"
    message += "    " + sp("RandomToValue") + "\n"
    message += "    " + sp("RandomThroughValue") + "\n"
    message += "    " + sp("RandomWithinRange")
    print(message)
    exit(EXIT_SUCCESS)
}
