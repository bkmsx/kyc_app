//
//  Constants.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct UserProfiles {
    static let userId = "userId"
    static let countryCode = "countryCode"
    static let phoneNumber = "phoneNumber"
    static let dateOfBirth = "dateOfBirth"
    static let deviceSecurityEnable = "deviceSecurityEnable"
    static let email = "email"
    static let erc20Address = "erc20Address"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let securityToken = "securityToken"
    static let status = "status"
    static let token = "token"
    static let typeOfSecurity = "typeOfSecurity"
    static let citizenshipId = "citizenshipId"
    static let passportNumber = "passportNumber"
    static let passportPhoto = "passportPhoto"
    static let selfiePhoto = "selfiePhoto"
    static let password = "password"
    
    static let tempPassword = "tempPassword"
    static let tempEmail = "tempEmail"
    static let tempFirstName = "tempFirstName"
    static let tempLastName = "tempLastName"
    static let tempCountryCode = "tempCountryCode"
    static let tempPhoneNumber = "tempPhoneNumber"
    static let tempErc20Address = "tempErc20Address"
    static let tempDateOfBirth = "tempDateOfBirth"
    static let tempDeviceSecurityEnable = "tempDeviceSecurityEnable"
}

struct URLConstant {
    static let baseURL = "http://concordia.ventures/api"
    static let sendOTP = "/otp/send"
    static let verifyOTP = "/otp/verify"
    static let register = "/register"
    static let loginAccount = "/login/account"
    static let loginSecurityId = "/login/securityid"
    static let citizenshipList = "/citizenship/list"
    static let uploadPassport = "/upload/passport"
}

struct SegueIdentifiers {
    static let segueRegisterView = "segueRegisterView"
    static let segueVerifyOTP = "segueVerifyOTP"
    static let segueListProject = "segueListProject"
    static let segueCompleteRegister = "segueCompleteRegister"
    static let segueFromLogin = "segueFromLogin"
    static let segueERC20Wallet = "segueERC20Wallet"
}

struct Colors {
    static let lightBlue = 0xff009cff
    static let easyBlue = 0xaa009cff
    static let lightGray = 0xff7a7777
    static let darkGray = 0xff656363
}
