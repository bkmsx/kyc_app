//
//  WalletCategory.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation
struct WalletCategory {
    let methodName: String?
    var wallets: [WalletAddress] = []
    
    init(dic: [String:Any]) {
        methodName = dic["method_name"] as? String ?? nil
        let walletsDic = dic["wallets"] as! [[String:Any]]
        for walletDic in walletsDic {
            let wallet = WalletAddress.init(dic: walletDic)
            wallets.append(wallet)
        }
    }
}
