//
//  Citizenships.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/2/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct CitizenshipModel {
    let id: Int
    let nationality: String
    
    init(dictionary: [String: Any]) {
        id = dictionary["nationality_id"] as! Int
        nationality = dictionary["nationality"] as! String
    }
}
