//
//  ProjectModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/8/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct ProjectModel {
    let id: Int
    let name: String
    let shortDescription: String
    let longDescription: String
    let thumbnail: String
    let enlargedPic: String
    let websiteURL: String
    let contactEmail: String
    let totalRaised: Int
    let maxRaised: Int
    let participateState: Int // 0=no, 1 = pending, 2= confirm
    let participateApplicationDate: String
    let participateConfirmedDate: String
    let participateAmount: Int
    let participateMethod: String //USD or ETH or BTC or XXX
    let grossPricePerTokenUSD: Float
    let grossPricePerTokenETH: Float
    let grossPricePerTokenXXX: Float
    let XXXValue: String
    
    init() {
        id = 0
        name = "W Green Pay"
        shortDescription = "W Green Pay (\"WGP\") is a Stellar-compliant token that operates on the Stellar blockchain."
        longDescription = "Following the Korean government’s pledge made at Copenhagen Accord in 2009, the country aims to reduce GHG emission by 37% by 2030. The Korean government selected W-Foundation to lead the “Nation-wide Public Movement to Reduce GHG Emission (HOOXI Campaign)"
        thumbnail = "http://www.wpay.sg/img/W28x28.png"
        enlargedPic = "http://www.wpay.sg/img/W28x28.png"
        websiteURL = "http://www.wpay.sg/"
        contactEmail = "hello@wpay.sg"
        totalRaised = 10000
        maxRaised = 2000000
        participateState = 1
        participateApplicationDate = "09/06/2018"
        participateConfirmedDate = ""
        participateAmount = 100
        participateMethod = "USD"
        grossPricePerTokenUSD = 0.123
        grossPricePerTokenETH = 0.212
        grossPricePerTokenXXX = 0.023
        XXXValue = ""
    }
}
