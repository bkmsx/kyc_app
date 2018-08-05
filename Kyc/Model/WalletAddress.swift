//
//  WalletAddress.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct WalletAddress {
    let walletId: Int?
    let methodId: Int?
    let address: String?
    
    init(dic: [String:Any]) {
        walletId = dic["wallet_id"] as? Int ?? nil
        methodId = dic["method_id"] as? Int ?? nil
        address = dic["address"] as? String ?? nil
    }
}
