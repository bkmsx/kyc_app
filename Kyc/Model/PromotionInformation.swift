//
//  PromotionInformation.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/13/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct PromotionInformation {
    let promotionId: Int?
    let projectId: Int?
    let title: String?
    let subTitle: String?
    let bannerImage: String?
    let useDefaultBanner: Int?
    let caption: String?
    let shortDes: String?
    let detailDes: String?
    let exampleDes: String?
    let freeTokens: Int?
    let createdDate: String?
    let updatedDate: String?

    init(dic: [String:Any]) {
        promotionId = dic["id"] as? Int ?? nil
        projectId = dic["project_id"] as? Int ?? nil
        title = dic["title"] as? String ?? nil
        subTitle = dic["sub_title"] as? String ?? nil
        bannerImage = dic["banner_image"] as? String ?? nil
        caption = dic["caption"] as? String ?? nil
        shortDes = dic["short_description"] as? String ?? nil
        detailDes = dic["detailed_description"] as? String ?? nil
        exampleDes = dic["example_description"] as? String ?? nil
        freeTokens = dic["free_tokens_per_share"] as? Int ?? nil
        createdDate = dic["created_at"] as? String ?? nil
        updatedDate = dic["updated_at"] as? String ?? nil
        useDefaultBanner = dic["default_banner"] as? Int ?? 1
    }
}
