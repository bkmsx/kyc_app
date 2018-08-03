//
//  PaymentMethodModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/31/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct PaymentMethodModel {
    let methodName: String?
    let methodId: Int?
    let price: String?
    let type: String?
    let accountName: String?
    let holderAddress: String?
    let accountNumber: String?
    let swiftCode: String?
    let bankName: String?
    let bankAddress: String?
    let walletAddress: String?
    
    init(dic: [String:Any]) {
        methodId = dic["method_id"] as? Int ?? nil
        methodName = dic["method_name"] as? String ?? nil
        price = dic["price_per_token"] as? String ?? nil
        type = dic["method_type"] as? String ?? nil
        accountName = dic["account_name"] as? String ?? nil
        holderAddress = dic["holder_address"] as? String ?? nil
        accountNumber = dic["account_number"] as? String ?? nil
        swiftCode = dic["swift_code"] as? String ?? nil
        bankName = dic["bank_name"] as? String ?? nil
        bankAddress = dic["bank_address"] as? String ?? nil
        walletAddress = dic["wallet_address"] as? String ?? nil
    }
}

