//
//  AppPaymentMethod.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct AppPaymentMethod {
    let id: Int?
    let name: String?
    let type: String?
    let createdAt: String?
    let updatedAt: String?
    
    init(dic: [String:Any]) {
        id = dic["id"] as? Int ?? nil
        name = dic["name"] as? String ?? nil
        type = dic["type"] as? String ?? nil
        createdAt = dic["created_at"] as? String ?? nil
        updatedAt = dic["updated_at"] as? String ?? nil
    }
}
