//
//  VerifyOTPViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Toast_Swift

class VerifyOTPViewController: ParticipateCommonController, CodeInputViewDelegate {
    //Inside
    var code = ""
    
    @IBOutlet weak var continueImageButton: ImageButton!
    
    //MARK: - Custom views
    override func customViews() {
        continueImageButton.delegate = self
        setupOTPInput()
    }
    
    override func imageButtonClick(_ sender: Any) {
        verifyOTP()
    }
    
    func setupOTPInput() {
        let OTPWidth = Int(CodeInputView.OTP_LENGTH * CodeInputView.NUMBER_WIDTH + CodeInputView.NUMBER_SPACE)
        let frame = CGRect(x: (Int(view.frame.width) - OTPWidth) / 2, y: 242, width: OTPWidth, height: CodeInputView.INPUT_HEIGHT)
        let codeInputView = CodeInputView(frame: frame)
        codeInputView.delegate = self
        view.addSubview(codeInputView)
    }

    func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String) {
        self.code = code
    }
    
    //MARK: - Call API
    @IBAction func resendOTP(_ sender: Any) {
        let currentTime = Int(Date().timeIntervalSince1970)
        let otpTime = UserDefaults.standard.integer(forKey: UserProfiles.OTPTime)
        if (currentTime - otpTime < 60) {
            makeToast("You can resend OTP code after 60 senconds")
            return
        }
        let countryCode = UserDefaults.standard.object(forKey: UserProfiles.tempCountryCode)!
        let phoneNumber = UserDefaults.standard.object(forKey: UserProfiles.tempPhoneNumber)!
        let params = [
            "country_code" : countryCode,
            "phone_number" : phoneNumber,
            "via" : "sms"
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { _ in
            self.makeToast("OTP code was sent")
            let currentTime = Int(Date().timeIntervalSince1970)
            UserDefaults.standard.set(currentTime, forKey: UserProfiles.OTPTime)
        }
    }
    
    func verifyOTP() {
        let countryCode = UserDefaults.standard.object(forKey: UserProfiles.tempCountryCode)!
        let phoneNumber = UserDefaults.standard.object(forKey: UserProfiles.tempPhoneNumber)!
        let params = [
            "otp_code" : code,
            "country_code" : countryCode,
            "phone_number" : phoneNumber
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.verifyOTP, method: .post, parameters: params, headers: nil) { _ in
            self.showMessage(message: "Your registration is successful! Welcome to Concordia Ventures, by Novum Capital!", buttonName: "Continue"){ alert in
                self.submitUserProfile()
            }
        }
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
            "referral_code" : UserDefaults.standard.string(forKey: UserProfiles.tempReferralCode)!,
            "device_id" : "23232",
            "validation" : 0,
            "platform": "iOS"
            ] as [String : Any]
        
        httpRequest(URLConstant.baseURL + URLConstant.register, method: .post, parameters: params, headers: nil) { (json) in
            let user = UserModel(dictionary: json["user"] as! [String : Any])
            user.saveToLocal()
            self.removeTempInformation()
            self.gotoUploadPassport()
        }
    }
    
    //MARK: - Success submit profiles
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
    
    //MARK: - Navigations
    func gotoUploadPassport() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UploadPassportViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - Dialog
    func showMessage(message: String, buttonName: String, handler:((UIAlertAction) -> Swift.Void)?=nil) {
        let alert = UIAlertController.init(title: "Verify OTP", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: buttonName, style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }

}
