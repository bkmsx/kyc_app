//
//  UserModel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/2/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let userId: Int!
    let countryCode: Int!
    let phoneNumber: String!
    let dateOfBirth: String!
    let deviceSecurityEnable: String!
    let email: String!
    let erc20Address: String!
    let firstName: String!
    let lastName: String!
    let securityToken: String!
    let status: String!
    let token: String!
    let typeOfSecurity: String!
    let citizenshipId: Int!
    let passportNumber: String!
    let passportPhoto: String!
    let selfiePhoto: String!
    
    init(dictionary: [String:Any]) {
        userId = dictionary["id"] as? Int ?? nil
        countryCode = dictionary["country_code"] as? Int ?? nil
        phoneNumber = dictionary["phone_number"] as? String ?? nil
        dateOfBirth = dictionary["date_of_birth"] as? String ?? nil
        passportNumber = dictionary["passport_number"] as? String ?? nil
        deviceSecurityEnable = dictionary["device_security_enable"] as? String ?? nil
        email = dictionary["email"] as? String ?? nil
        erc20Address = dictionary["erc20_address"] as? String ?? nil
        firstName = dictionary["first_name"] as? String ?? nil
        lastName = dictionary["last_name"] as? String ?? nil
        securityToken = dictionary["security_token"] as? String ?? nil
        status = dictionary["status"] as? String ?? nil
        token = dictionary["token"] as? String ?? nil
        typeOfSecurity = dictionary["type_of_security"] as? String ?? nil
        citizenshipId = dictionary["citizenship_id"] as? Int ?? nil
        passportPhoto = dictionary["passport_photo"] as? String ?? nil
        selfiePhoto = dictionary["selfie_photo"] as? String ?? nil
    }
    
    func saveToLocal() {
        UserDefaults.standard.set(userId, forKey: UserProfiles.userId)
        UserDefaults.standard.set(countryCode, forKey: UserProfiles.countryCode)
        UserDefaults.standard.set(phoneNumber, forKey: UserProfiles.phoneNumber)
        UserDefaults.standard.set(dateOfBirth, forKey: UserProfiles.dateOfBirth)
        UserDefaults.standard.set(passportNumber, forKey: UserProfiles.passportNumber)
        UserDefaults.standard.set(deviceSecurityEnable, forKey: UserProfiles.deviceSecurityEnable)
        UserDefaults.standard.set(email, forKey: UserProfiles.email)
        UserDefaults.standard.set(erc20Address, forKey: UserProfiles.erc20Address)
        UserDefaults.standard.set(firstName, forKey: UserProfiles.firstName)
        UserDefaults.standard.set(lastName, forKey: UserProfiles.lastName)
        UserDefaults.standard.set(securityToken, forKey: UserProfiles.securityToken)
        UserDefaults.standard.set(status, forKey: UserProfiles.status)
        UserDefaults.standard.set(token, forKey: UserProfiles.token)
        UserDefaults.standard.set(typeOfSecurity, forKey: UserProfiles.typeOfSecurity)
        UserDefaults.standard.set(citizenshipId, forKey: UserProfiles.citizenshipId)
        UserDefaults.standard.set(passportPhoto, forKey: UserProfiles.passportPhoto)
        UserDefaults.standard.set(selfiePhoto, forKey: UserProfiles.selfiePhoto)
    }
    
    
}
