//
//  VerifyOTPViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class VerifyOTPViewController: UIViewController {
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBAction func `continue`(_ sender: Any) {
        verifyOTP()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func verifyOTP() {
        let countryCode = UserDefaults.standard.object(forKey: UserProfiles.countryCode)!
        let phoneNumber = UserDefaults.standard.object(forKey: UserProfiles.phoneNumber)!
        let params = [
            "otp_code" : otpTextField.text!,
            "country_code" : countryCode,
            "phone_number" : phoneNumber
        ] as [String : Any]
        Alamofire.request(URLConstant.baseURL + URLConstant.verifyOTP, method: .post, parameters: params).responseJSON { response in
            print(response)
        }
    }
}
