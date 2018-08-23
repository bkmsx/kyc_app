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
    static let NICE_CODES = ["Afghanistan +93","Albania +355","Algeria +213","American Samoa +1684","Andorra +376","Angola +244","Anguilla +1264","Antarctica +0","Antigua and Barbuda +1268","Argentina +54","Armenia +374","Aruba +297","Australia +61","Austria +43","Azerbaijan +994","Bahamas +1242","Bahrain +973","Bangladesh +880","Barbados +1246","Belarus +375","Belgium +32","Belize +501","Benin +229","Bermuda +1441","Bhutan +975","Bolivia +591","Bosnia and Herzegovina +387","Botswana +267","Bouvet Island +0","Brazil +55","British Indian Ocean Territory +246","Brunei Darussalam +673","Bulgaria +359","Burkina Faso +226","Burundi +257","Cambodia +855","Cameroon +237","Canada +1","Cape Verde +238","Cayman Islands +1345","Central African Republic +236","Chad +235","Chile +56","China +86","Christmas Island +61","Cocos (Keeling) Islands +672","Colombia +57","Comoros +269","Congo +242","Cook Islands +682","Costa Rica +506","Cote D'Ivoire +225","Croatia +385","Cuba +53","Cyprus +357","Czech Republic +420","Denmark +45","Djibouti +253","Dominica +1767","Dominican Republic +1809","Ecuador +593","Egypt +20","El Salvador +503","Equatorial Guinea +240","Eritrea +291","Estonia +372","Ethiopia +251","Falkland Islands (Malvinas) +500","Faroe Islands +298","Fiji +679","Finland +358","France +33","French Guiana +594","French Polynesia +689","French Southern Territories +0","Gabon +241","Gambia +220","Georgia +995","Germany +49","Ghana +233","Gibraltar +350","Greece +30","Greenland +299","Grenada +1473","Guadeloupe +590","Guam +1671","Guatemala +502","Guinea +224","Guinea-Bissau +245","Guyana +592","Haiti +509","Holy See +39","Honduras +504","Hong Kong +852","Hungary +36","Iceland +354","India +91","Indonesia +62","Iran +98","Iraq +964","Ireland +353","Israel +972","Italy +39","Jamaica +1876","Japan +81","Jordan +962","Kazakhstan +7","Kenya +254","Kiribati +686","Korea Republic +850","Korea +82","Kuwait +965","Kyrgyzstan +996","Lao People's Democratic Republic +856","Latvia +371","Lebanon +961","Lesotho +266","Liberia +231","Libyan Arab Jamahiriya +218","Liechtenstein +423","Lithuania +370","Luxembourg +352","Macao +853","Macedonia +389","Madagascar +261","Malawi +265","Malaysia +60","Maldives +960","Mali +223","Malta +356","Marshall Islands +692","Martinique +596","Mauritania +222","Mauritius +230","Mayotte +269","Mexico +52","Micronesia +691","Moldova +373","Monaco +377","Mongolia +976","Montserrat +1664","Morocco +212","Mozambique +258","Myanmar +95","Namibia +264","Nauru +674","Nepal +977","Netherlands +31","Netherlands Antilles +599","New Caledonia +687","New Zealand +64","Nicaragua +505","Niger +227","Nigeria +234","Niue +683","Norfolk Island +672","Northern Mariana Islands +1670","Norway +47","Oman +968","Pakistan +92","Palau +680","Palestinian Territory, Occupied +970","Panama +507","Papua New Guinea +675","Paraguay +595","Peru +51","Philippines +63","Pitcairn +0","Poland +48","Portugal +351","Puerto Rico +1787","Qatar +974","Reunion +262","Romania +40","Russian Federation +70","Rwanda +250","Saint Helena +290","Saint Kitts and Nevis +1869","Saint Lucia +1758","Saint Pierre and Miquelon +508","Saint Vincent and the Grenadines +1784","Samoa +684","San Marino +378","Sao Tome and Principe +239","Saudi Arabia +966","Senegal +221","Serbia and Montenegro +381","Seychelles +248","Sierra Leone +232","Singapore +65","Slovakia +421","Slovenia +386","Solomon Islands +677","Somalia +252","South Africa +27","Spain +34","Sri Lanka +94","Sudan +249","Suriname +597","Svalbard and Jan Mayen +47","Swaziland +268","Sweden +46","Switzerland +41","Syrian Arab Republic +963","Taiwan +886","Tajikistan +992","Tanzania +255","Thailand +66","Timor-Leste +670","Togo +228","Tokelau +690","Tonga +676","Trinidad and Tobago +1868","Tunisia +216","Turkey +90","Turkmenistan +7370","Turks and Caicos Islands +1649","Tuvalu +688","Uganda +256","Ukraine +380","United Arab Emirates +971","United Kingdom +44","United States +1","Uruguay +598","Uzbekistan +998","Vanuatu +678","Venezuela +58","Viet Nam +84","Virgin Islands, British +1284","Virgin Islands, U.s. +1340","Wallis and Futuna +681","Western Sahara +212","Yemen +967","Zambia +260","Zimbabwe +263"]
    static let PHONE_CODES = ["+93","+355","+213","+1684","+376","+244","+1264","+0","+1268","+54","+374","+297","+61","+43","+994","+1242","+973","+880","+1246","+375","+32","+501","+229","+1441","+975","+591","+387","+267","+0","+55","+246","+673","+359","+226","+257","+855","+237","+1","+238","+1345","+236","+235","+56","+86","+61","+672","+57","+269","+242","+682","+506","+225","+385","+53","+357","+420","+45","+253","+1767","+1809","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+594","+689","+0","+241","+220","+995","+49","+233","+350","+30","+299","+1473","+590","+1671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+972","+39","+1876","+81","+962","+7","+254","+686","+850","+82","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+596","+222","+230","+269","+52","+691","+373","+377","+976","+1664","+212","+258","+95","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+1670","+47","+968","+92","+680","+970","+507","+675","+595","+51","+63","+0","+48","+351","+1787","+974","+262","+40","+70","+250","+290","+1869","+1758","+508","+1784","+684","+378","+239","+966","+221","+381","+248","+232","+65","+421","+386","+677","+252","+27","+34","+94","+249","+597","+47","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1868","+216","+90","+7370","+1649","+688","+256","+380","+971","+44","+1","+598","+998","+678","+58","+84","+1284","+1340","+681","+212","+967","+260","+263"]
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
    static let referralCode = "referralCode"
    static let referralBy = "referralBy"
    
    static let tempPassword = "tempPassword"
    static let tempEmail = "tempEmail"
    static let tempFirstName = "tempFirstName"
    static let tempLastName = "tempLastName"
    static let tempCountryCode = "tempCountryCode"
    static let tempPhoneNumber = "tempPhoneNumber"
    static let tempErc20Address = "tempErc20Address"
    static let tempDateOfBirth = "tempDateOfBirth"
    static let tempDeviceSecurityEnable = "tempDeviceSecurityEnable"
    static let tempReferralCode = "tempReferralCode"
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
    static let projectShare = "/project/share"
    static let updateReferralCode = "/update-referral-code"
    static let bonusList = "/referral-bonus-list"
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
    static let SettingViewController = "SettingViewController"
    static let ReferralCodeController = "ReferralCodeController"
}

struct Colors {
    static let lightBlue = 0x008ce5
    static let easyBlue = 0x008ce5
    static let lightGray = 0x7a7777
    static let darkGray = 0x656363
}
