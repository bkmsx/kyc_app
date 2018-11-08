//
//  BonusToken.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/14/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct BonusToken {
    let userName: String?
    let token: String?
    let amount: String?
    let tier: Int?
    
    init(dic: [String:Any]) {
        userName = dic["user_name"] as? String ?? nil
        token = dic["token"] as? String ?? nil
        amount = dic["amount"] as? String ?? "0.0"
        tier = dic["tier"] as? Int ?? 0
    }
}
