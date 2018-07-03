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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func `continue`(_ sender: Any) {
        verifyOTP()
//        gotoUploadPassport()
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
        activityIndicator.startAnimating()
        Alamofire.request(URLConstant.baseURL + URLConstant.verifyOTP, method: .post, parameters: params).responseJSON { response in
            let JSON = response.result.value as! NSDictionary
            let resultCode = JSON["code"] as! Int
            if (resultCode == 200) {
                self.showMessage(message: "Register successfully!", buttonName: "Continue"){ alert in
                    self.submitUserProfile()
                }
            } else {
                self.activityIndicator.stopAnimating()
                let message = JSON["message"] as! String
                self.showMessage(message: message, buttonName: "Try again", handler: nil)
            }
        }
    }
    
    func gotoUploadPassport() {
        performSegue(withIdentifier: "segueUploadPassport", sender: nil)
    }
    
    func submitUserProfile() {
        
        let params = [
            "first_name" : UserDefaults.standard.object(forKey: UserProfiles.firstName)!,
            "last_name" : UserDefaults.standard.object(forKey: UserProfiles.lastName)!,
            "date_of_birth" : UserDefaults.standard.object(forKey: UserProfiles.dateOfBirth)!,
            "email" : UserDefaults.standard.object(forKey: UserProfiles.email)!,
            "password" : UserDefaults.standard.object(forKey: UserProfiles.password)!,
            "country_code" : UserDefaults.standard.object(forKey: UserProfiles.countryCode)!,
            "phone_number" : UserDefaults.standard.object(forKey: UserProfiles.phoneNumber)!,
            "device_security_enable" : UserDefaults.standard.object(forKey: UserProfiles.deviceSecurityEnable)!,
            "type_of_security" : "TOUCHID",
            "erc20_address" : UserDefaults.standard.object(forKey: UserProfiles.erc20Address)!,
            "device_id" : "23232",
            "validation" : 0,
            "platform": "iOS"
            ] as [String : Any]
        
        Alamofire.request(URLConstant.baseURL + URLConstant.register, method: .post, parameters: params)
            .responseJSON{ response in
                let json = response.result.value as! [String:Any]
                let user = UserModel(dictionary: json["user"] as! [String : Any])
                user.saveToLocal()
                self.activityIndicator.stopAnimating()
               self.gotoUploadPassport()
        }
    }
    
    func showMessage(message: String, buttonName: String, handler:((UIAlertAction) -> Swift.Void)?=nil) {
        let alert = UIAlertController.init(title: "Verify OTP", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: buttonName, style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != "segueUploadPassport"
    }
}
