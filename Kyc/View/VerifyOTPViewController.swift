//
//  VerifyOTPViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class VerifyOTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func `continue`(_ sender: Any) {
        verifyOTP()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.delegate = self
    }

    func verifyOTP() {
        let countryCode = UserDefaults.standard.object(forKey: UserProfiles.tempCountryCode)!
        let phoneNumber = UserDefaults.standard.object(forKey: UserProfiles.tempPhoneNumber)!
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
            "first_name" : UserDefaults.standard.object(forKey: UserProfiles.tempFirstName)!,
            "last_name" : UserDefaults.standard.object(forKey: UserProfiles.tempLastName)!,
            "date_of_birth" : UserDefaults.standard.object(forKey: UserProfiles.tempDateOfBirth)!,
            "email" : UserDefaults.standard.object(forKey: UserProfiles.tempEmail)!,
            "password" : UserDefaults.standard.object(forKey: UserProfiles.tempPassword)!,
            "country_code" : UserDefaults.standard.object(forKey: UserProfiles.tempCountryCode)!,
            "phone_number" : UserDefaults.standard.object(forKey: UserProfiles.tempPhoneNumber)!,
            "device_security_enable" : UserDefaults.standard.object(forKey: UserProfiles.tempDeviceSecurityEnable)!,
            "type_of_security" : "TOUCHID",
            "erc20_address" : UserDefaults.standard.object(forKey: UserProfiles.tempErc20Address)!,
            "device_id" : "23232",
            "validation" : 0,
            "platform": "iOS"
            ] as [String : Any]
        
        Alamofire.request(URLConstant.baseURL + URLConstant.register, method: .post, parameters: params)
            .responseJSON{ response in
                let json = response.result.value as! [String:Any]
                let user = UserModel(dictionary: json["user"] as! [String : Any])
                user.saveToLocal()
                self.removeTempInformation()
                self.activityIndicator.stopAnimating()
               self.gotoUploadPassport()
        }
    }
    
    func removeTempInformation() {
        let pref = UserDefaults.standard
        pref.removeObject(forKey: UserProfiles.tempFirstName)
        pref.removeObject(forKey: UserProfiles.tempLastName)
        pref.removeObject(forKey: UserProfiles.tempEmail)
        pref.removeObject(forKey: UserProfiles.tempCountryCode)
        pref.removeObject(forKey: UserProfiles.tempPassword)
        pref.removeObject(forKey: UserProfiles.tempDateOfBirth)
        pref.removeObject(forKey: UserProfiles.tempErc20Address)
        pref.removeObject(forKey: UserProfiles.tempPhoneNumber)
        pref.removeObject(forKey: UserProfiles.tempDeviceSecurityEnable)
    }
    
    func showMessage(message: String, buttonName: String, handler:((UIAlertAction) -> Swift.Void)?=nil) {
        let alert = UIAlertController.init(title: "Verify OTP", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: buttonName, style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != "segueUploadPassport"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
