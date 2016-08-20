//
//  Random.swift
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

internal extension Array where Element : Hashable {
    fileprivate func removeDuplicates() -> Array {
        var seen: [Element : Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

public struct Random {

    /// Generates a random fake gender: "Male" or "Female".
    public static func gender() -> String {
        return Bool.random() ? "Male" : "Female"
    }

    public enum USState: String {
        case _Any
        case Alabama
        case Alaska
        case Arizona
        case Arkansas
        case California
        case Colorado
        case Connecticut
        case Delaware
        case Florida
        case Georgia
        case Hawaii
        case Idaho
        case Illinois
        case Indiana
        case Iowa
        case Kansas
        case Kentucky
        case Louisiana
        case Maine
        case Maryland
        case Massachusetts
        case Michigan
        case Minnesota
        case Mississippi
        case Missouri
        case Montana
        case Nebraska
        case Nevada
        case NewHampshire
        case NewJersey
        case NewMexico
        case NewYork
        case NorthCarolina
        case NorthDakota
        case Ohio
        case Oklahoma
        case Oregon
        case Pennsylvania
        case PuertoRico
        case RhodeIsland
        case SouthCarolina
        case SouthDakota
        case Tennessee
        case Texas
        case Utah
        case Vermont
        case Virginia
        case Washington
        case WashingtonDC
        case WestVirginia
        case Wisconsin
        case Wyoming
    }

    internal static let areaCodes: [USState : [Int]] = [
        .Alabama         : [205, 251, 256, 334, 938],
        .Alaska          : [907],
        .Arizona         : [480, 520, 602, 923, 928],
        .Arkansas        : [479, 501, 870],
        .California      : [209, 213, 310, 323, 408, 415, 424, 442, 510, 530,
                            559, 562, 619, 626, 650, 657, 661, 669, 707, 714,
                            747, 760, 805, 818, 831, 858, 909, 916, 925, 949,
                            951],
        .Colorado        : [303, 719, 720, 970],
        .Connecticut     : [203, 475, 860],
        .Delaware        : [302],
        .Florida         : [239, 305, 321, 352, 386, 407, 561, 727, 754, 772,
                            786, 813, 850, 863, 904, 941, 954],
        .Georgia         : [229, 404, 470, 478, 678, 706, 762, 770, 912],
        .Hawaii          : [808],
        .Idaho           : [208],
        .Illinois        : [217, 224, 309, 312, 331, 618, 630, 708, 773, 779,
                            815, 847, 872],
        .Indiana         : [219, 260, 317, 574, 765, 812],
        .Iowa            : [319, 515, 563, 641, 712],
        .Kansas          : [316, 620, 785, 913],
        .Kentucky        : [270, 502, 606, 859],
        .Louisiana       : [225, 318, 337, 504, 985],
        .Maine           : [207],
        .Maryland        : [240, 301, 410, 443, 667],
        .Massachusetts   : [339, 351, 413, 508, 617, 774, 781, 857, 978],
        .Michigan        : [231, 248, 269, 313, 517, 586, 616, 734, 810, 906,
                            947, 989],
        .Minnesota       : [218, 320, 507, 612, 651, 763, 952],
        .Mississippi     : [228, 601, 662, 769],
        .Missouri        : [314, 417, 573, 636, 660, 816],
        .Montana         : [406],
        .Nebraska        : [308, 402, 531],
        .Nevada          : [702, 725, 775],
        .NewHampshire    : [603],
        .NewJersey       : [201, 551, 609, 732, 848, 856, 862, 908, 973],
        .NewMexico       : [505, 575],
        .NewYork         : [212, 315, 347, 516, 518, 585, 607, 631, 646, 716,
                            718, 845, 914, 917, 929],
        .NorthCarolina   : [252, 336, 704, 828, 910, 919, 980, 984],
        .NorthDakota     : [701],
        .Ohio            : [216, 234, 330, 419, 440, 513, 567, 614, 740, 937],
        .Oklahoma        : [405, 539, 580, 918],
        .Oregon          : [458, 503, 541, 971],
        .Pennsylvania    : [215, 267, 272, 412, 484, 570, 610, 717, 724, 814,
                            878],
        .PuertoRico      : [787, 939],
        .RhodeIsland     : [401],
        .SouthCarolina   : [803, 843, 864],
        .SouthDakota     : [605],
        .Tennessee       : [423, 615, 731, 865, 901, 931],
        .Texas           : [210, 214, 254, 281, 325, 346, 361, 409, 430, 432,
                            469, 512, 682, 713, 737, 806, 817, 830, 832, 903,
                            915, 936, 940, 956, 972, 979],
        .Utah            : [385, 435, 801],
        .Vermont         : [802],
        .Virginia        : [276, 434, 540, 571, 703, 757, 804],
        .Washington      : [206, 253, 360, 425, 509],
        .WashingtonDC    : [202],
        .WestVirginia    : [304, 681],
        .Wisconsin       : [262, 414, 534, 608, 715, 920],
        .Wyoming         : [307]
    ]

    /// Generates a random fake phone number for a given US state.
    ///
    /// - Parameter state: The US state for the area code of the generated
    ///             number. Default value is `._Any`.
    public static func phoneNumber(_ state: USState = ._Any) -> Int64 {
        let areaCode = state == ._Any
            ? areaCodes.random!.1.random!
            : areaCodes[state]!.random!
        let number = (1...7).reduce(String(areaCode)) { number, _ in
            return number + String(Int.random(0...9))
        }
        return Int64(number)!
    }

    public enum GenderType {
        case male
        case female
        case either
    }

    public enum HonorificType {

        case _Any, common, formal, professional, religious

        private func anyProperties<T>(_ block: (HonorificType) -> [T]) -> [T] {
            return [HonorificType.common, HonorificType.formal, HonorificType.professional, HonorificType.religious].reduce([]) {
                $0 + block($1)
            }
        }

        internal func titles(_ gender: GenderType) -> [String] {
            switch (self, gender) {
            case (.common, .male):
                return ["Mr.", "Master", "Mx."]
            case (.common, .female):
                return ["Mz.", "Ms.", "Mrs.", "Mx."]
            case (.formal, .male):
                return ["Sir", "Lord"]
            case (.formal, .female):
                return ["Madam", "Lady"]
            case (.professional, _):
                return ["Dr.", "Prof."]
            case (.religious, .male):
                return ["Br.", "Fr.", "Pr.", "Elder", "Rabbi", "Rev."]
            case (.religious, .female):
                return ["Sr.", "Rev."]
            case (_, .either):
                return (titles(.male) + titles(.female)).removeDuplicates()
            default:
                return anyProperties { $0.titles(gender) }
            }
        }
    }

    /// Generates a random English honorific for a given type.
    ///
    /// - Parameters:
    ///     - type: The type of the generated honorific.
    ///       Default value is `._Any`.
    ///     - gender: The gender for the generated honorific.
    ///       Default value is `.Either`.
    public static func englishHonorific(type honorificType: HonorificType = ._Any, gender: GenderType = .either) -> String {
        return honorificType.titles(gender).random!
    }

}
