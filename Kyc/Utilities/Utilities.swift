//
//  Utilities.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import Foundation

struct Utilities {
    static func saveAccountDetailsToKeyChain(account: String, password: String) {
        guard !account.isEmpty, !password.isEmpty else {
            return
        }
        UserDefaults.standard.set(account, forKey: UserProfiles.account)
        
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
        } catch {
            print("Error saving password")
        }
        print(password)
    }
    
    static func getPassword(account: String) -> String {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account)
        do {
            let password = try passwordItem.readPassword()
            return password
        } catch KeychainPasswordItem.KeychainError.noPassword {
            print("No saved password")
        } catch {
            print("Unhandled error")
        }
        return ""
    }
 }

