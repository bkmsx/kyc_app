//
//  ContryModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/4/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct CountryModel {
    let id: Int
    let country: String
    
    init(dictionary: [String:Any]) {
        id = dictionary["country_id"] as! Int
        country = dictionary["country"] as! String
    }
}
