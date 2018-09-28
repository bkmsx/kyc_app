//
//  ProjectModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/8/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct ProjectModel {
    let projectId: Int?
    let logo: String?
    let title: String?
    let addedDate: String?
    let shortDescription: String?
    let detailedDescription: String?
    let userParticipated: Bool?
    let currentDiscount: String?
    let currentSaleStart: String?
    let currentSaleEnd: String?
    let isPromoted: Int?
    let currentTier: String?
    let termUrl: String?
    var paymentMethods: [PaymentMethodModel] = []
    var salePeriods: [BonusTierModel] = []
    
    init(json: [String:Any]) {
       projectId = json["project_id"] as? Int ?? nil
        logo = json["logo"] as? String ?? nil
        title = json["title"] as? String ?? nil
        addedDate = json["added_date"] as? String ?? nil
        shortDescription = json["short_description"] as? String ?? nil
        detailedDescription = json["detailed_description"] as? String ?? nil
        userParticipated = json["user_participated"] as? Bool ?? nil
        currentDiscount = json["current_discount"] as? String ?? nil
        currentSaleStart = json["current_sale_start"] as? String ?? nil
        currentSaleEnd = json["current_sale_end"] as? String ?? nil
        isPromoted = json["promotion"] as? Int ?? 0
        currentTier = json["current_tier"] as? String ?? "Not started"
        termUrl = json["terms_url"] as? String ?? "https://kycapp.concordia.ventures/terms"
        let payments = json["payment_methods"] as? [[String:Any]] ?? nil
        if let payments = payments {
            for paymentDic in payments {
                let paymentMethod = PaymentMethodModel(dic: paymentDic)
                paymentMethods.append(paymentMethod)
            }
        }
        let periods = json["sale_periods"] as? [[String:Any]] ?? nil
        if let periods = periods {
            for period in periods {
                let bonusTier = BonusTierModel(dic: period)
                salePeriods.append(bonusTier)
            }
        }
     }
}
