//
//  Constants.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct Configs {
    static let OTP_LENGTH = 4
    static let PHONE_CODES = ["+93","+355","+213","+1-684","+376","+244","+1-264","+672","+1-268","+54","+374","+297","+61","+43","+994","+1-242","+973","+880","+1-246","+375","+32","+501","+229","+1-441","+975","+591","+387","+267","+55","+673","+359","+226","+257","+855","+237","+1","+238","+1-345","+236","+235","+56","+86","+53","+61","+57","+269","+243","+242","+682","+506","+225","+385","+53","+357","+420","+45","+253","+1-767","+1-809","+1-829","+670","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+594","+689","+241","+220","+995","+49","+233","+350","+30","+299","+1-473","+590","+1-671","+502","+224","+245","+592","+509","+504","+852","+36","+354","+91","+62","+98","+964","+353","+972","+39","+1-876","+81","+962","+7","+254","+686","+850","+82","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+596","+222","+230","+269","+52","+691","+373","+377","+976","+1-664","+212","+258","+95","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+1-670","+47","+968","+92","+680","+970","+507","+675","+595","+51","+63","+48","+351","+1-787","+1-939","+974","+262","+40","+7","+250","+290","+1-869","+1-758","+508","+1-784","+685","+378","+239","+966","+221","+248","+232","+65","+421","+386","+677","+252","+27","+34","+94","+249","+597","+268","+46","+41","+963","+886","+992","+255","+66","+690","+676","+1-868","+216","+90","+993","+1-649","+688","+256","+380","+971","+44","+1","+598","+998","+678","+418","+58","+84","+1-284","+1-340","+681","+967","+260","+263"]
}

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
    static let citizenship = "citizenship"
    static let country = "country"
    
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
    static let baseURL = "http://kycapp.concordia.ventures/api"
    static let sendOTP = "/otp/send"
    static let verifyOTP = "/otp/verify"
    static let register = "/register"
    static let loginAccount = "/login/account"
    static let loginSecurityId = "/login/securityid"
    static let citizenshipList = "/citizenship/list"
    static let uploadPassport = "/upload/passport"
    static let projectList = "/project/list"
    static let projectDetail = "/project/detail"
    static let changePassword = "/change-password"
    static let participate = "/project/participate"
    static let participateHistory = "/project/participate-history"
    static let resetPassword = "/forgot-password"
    static let participateDelete = "/project/participate-delete"
    static let participateDetail = "/project/participate-detail"
    static let userWallets = "/user-wallets"
    static let addWallet = "/wallet-add"
    static let updateWallet = "/wallet-update"
    static let deleteWallet = "/wallet-delete"
    static let paymentMethods = "/app-payment-methods"
    static let updateUserInfor = "/update-personal-info"
}

struct SegueIdentifiers {
    static let segueRegisterView = "segueRegisterView"
    static let segueVerifyOTP = "segueVerifyOTP"
    static let segueListProject = "segueListProject"
    static let segueCompleteRegister = "segueCompleteRegister"
    static let segueFromLogin = "segueFromLogin"
    static let segueERC20Wallet = "segueERC20Wallet"
}

struct ViewControllerIdentifiers {
    static let ListProjectViewController = "ListProjectViewController"
    static let ProjectDetailViewController = "ProjectDetailViewController"
    static let AgreeTermConditionViewController = "AgreeTermConditionViewController"
    static let WalletInputController = "WalletInputController"
    static let SuccessTransactionViewController = "SuccessTransactionViewController"
    static let TransactionDetailController = "TransactionDetailController"
    static let UpdatePersonalInformationViewController = "UpdatePersonalInformationViewController"
    static let UpdatePassportViewController = "UpdatePassportViewController"
    static let UpdateWalletAddressViewController = "UpdateWalletAddressViewController"
    static let HistoryTableViewController = "HistoryTableViewController"
    static let PhoneListViewController = "PhoneListViewController"
    static let InvitationInforController = "InvitationInforController"
    static let UploadPassportViewController = "UploadPassportViewController"
    static let VerifyOTPViewController = "VerifyOTPViewController"
    static let CompleteRegisterViewController = "CompleteRegisterViewController"
    static let ProjectNavigationController = "ProjectNavigationController"
    static let LoginNavigationController = "LoginNavigationController"
    static let CompleteRetreivePasswordController = "CompleteRetreivePasswordController"
    static let USDDetailViewController = "USDDetailViewController"
    static let OTPUpdateMobileViewController = "OTPUpdateMobileViewController"
    static let ConfigurationViewController = "ConfigurationViewController"
    static let ChooseShareMethodViewController = "ChooseShareMethodViewController"
    static let ETHParticipateDetailViewController = "ETHParticipateDetailViewController"
    static let USDParticipateHistoryController = "USDParticipateHistoryController"
    static let WalletListController = "WalletListController"
    static let AddWalletController = "AddWalletController"
}

struct Colors {
    static let lightBlue = 0xff008ce5
    static let easyBlue = 0xaa008ce5
    static let lightGray = 0xff7a7777
    static let darkGray = 0xff656363
}
