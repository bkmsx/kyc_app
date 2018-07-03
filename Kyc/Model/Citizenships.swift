//
//  Citizenships.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/2/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct Citizeships: Codable {
    let code: Int
    let citizenships: [Citizenship]
}
struct Citizenship: Codable {
    let nationality_id: Int
    let nationality: String
}
