//
//  ParticipateHistoryModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/31/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct ParticipateHistoryModel {
    let projectId: Int?
    let logo: String?
    let title: String?
    let addedDate: String?
    let tokensPurchased: String?
    let paymentMode: String?
    let discount: String?
    let paymentStatus: String?
    let historyId: Int?
    let amount: String?
    let paymentDestination: PaymentMethodModel?
    let paymentSource: String?
    let price: String?
    let isPromoted: Int?
    
    init(dic: [String:Any]) {
        projectId = dic["project_id"] as? Int ?? nil
        logo = dic["logo"] as? String ?? nil
        title = dic["title"] as? String ?? nil
        addedDate = dic["added_date"] as? String ?? nil
        tokensPurchased = dic["tokens_purchased"] as? String ?? nil
        paymentMode = dic["payment_mode"] as? String ?? nil
        discount = dic["discount"] as? String ?? nil
        paymentStatus = dic["payment_status"] as? String ?? nil
        historyId = dic["history_id"] as? Int ?? nil
        amount = dic["amount"] as? String ?? nil
        if let paymentDesDic = dic["payment_destination"] as? [String:Any] {
            paymentDestination =  PaymentMethodModel(dic: paymentDesDic)
        } else {
            paymentDestination = nil
        }
        paymentSource = dic["payment_source"] as? String ?? nil
        price = dic["price_per_token"] as? String ?? nil
        isPromoted = dic["promotion"] as? Int ?? 0
    }
}
