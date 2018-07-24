//
//  Utilities.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

struct Utilities {
    static func saveAccountDetailsToKeyChain(account: String, password: String) {
        guard !account.isEmpty, !password.isEmpty else {
            return
        }
        UserDefaults.standard.set(account, forKey: UserProfiles.email
        )
        
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}

extension UITextField {
    func setBottomBorder(color: UIColor) {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


