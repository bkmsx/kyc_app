//
//  BonusTierModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 9/17/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct BonusTierModel {
    let title: String?
    let saleStart: String?
    let saleEnd: String?
    let discount: String?
    
    init(dic: [String:Any]) {
        title = dic["title"] as? String ?? nil
        saleStart = dic["sale_start"] as? String ?? ""
        saleEnd = dic["sale_end"] as? String ?? ""
        discount = dic["discount"] as? String ?? "0"
    }
}
