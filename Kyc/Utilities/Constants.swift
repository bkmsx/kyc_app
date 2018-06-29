//
//  Constants.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct UserProfiles {
    static let account = "userAccount"
    static let countryCode  = "countryCode"
    static let phoneNumber = "phoneNumber"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let dateOfBirth = "dateOfBirth"
    static let email = "email"
    static let password = "password"
    static let faceId = "faceId"
    static let erc20Address = "erc20Address"
}

struct URLConstant {
    static let baseURL = "http://concordia.ventures/api"
    static let sendOTP = "/otp/send"
    static let verifyOTP = "/otp/verify"
    static let register = "/register"
    static let loginAccount = "/login/acount"
    static let loginSecurityId = "/login/securityid"
    static let citizenshipList = "/citizenship/list"
    static let uploadPassport = "/upload/passport"
}
