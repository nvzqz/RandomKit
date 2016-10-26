//
//  DistributionMoment.swift
//  RandomKit
//
//  Created by phimage on 18/09/16.
//  Copyright © 2016 Nikolai Vazquez. All rights reserved.
//

import RandomKit

// From https://github.com/phimage/Arithmosophi
struct DistributionMoment {
    var M0: Double = 0
    var M1: Double = 0
    var M2: Double = 0
    var M3: Double = 0
    var M4: Double = 0
    
    init(data: [Double]) {
        M0 = Double(data.count)
        var n: Double = 0
        for x in data {
            let n1 = n
            n += 1
            let delta = x - M1
            let delta_n = delta / n
            let delta_n2 = delta_n * delta_n
            let term1 = delta * delta_n * n1
            M1 += delta_n
            let t4 = 6 * delta_n2 * M2 - 4 * delta_n * M3
            M4 += term1 * delta_n2 * (n*n - 3*n + 3) + t4
            let t3 = 3 * delta_n * M2
            M3 += term1 * delta_n * (n - 2) - t3
            M2 += term1
        }
    }
    
    var excessKurtosis: Double {
        return kurtosis - 3
    }
    
    var kurtosis: Double {
        return (M0*M4) / (M2*M2)
    }
    
    var skewness: Double {
        return M0.sqrt() * M3 / M2.pow(1.5)
    }
    
    var mean: Double {
        return M1
    }
    
    var variance: Double {
        return M2/(M0 - 1.0)
    }
    
    var standardDeviation: Double {
        return variance.sqrt()
    }
}
