//
//  OTPUpdateMobileViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/2/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class OTPUpdatePassportController: ParticipateCommonController, CodeInputViewDelegate {
    var countryCode: String?
    var phoneNumber: String?
    var citizenship: String?
    var country: String?
    var citizenshipId: Int?
    var passportNumber: String?
    var dob: String?
    var passportImage: UIImage?
    var selfieImage: UIImage?
    var code: String?
    
    @IBOutlet weak var imageButton: ImageButton!
    
    //MARK: - Custom Views
    override func customViews() {
        setupOTPInput()
        imageButton.delegate = self
    }
    
    //MARK: - Setup OTP input
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
    //MARK: - API
    @IBAction func resendOTP(_ sender: Any) {
        let currenTime = Int(Date().timeIntervalSince1970)
        let otpTime = UserDefaults.standard.integer(forKey: UserProfiles.OTPTime)
        if (currenTime - otpTime < 60) {
            makeToast("You can resend OTP after 60 seconds")
            return
        }
        let params = [
            "country_code" : countryCode!,
            "phone_number" : phoneNumber!,
            "via" : "sms"
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { (json) in
            self.view.makeToast("Resent OTP code")
            let currentTime = Int(Date().timeIntervalSince1970)
            UserDefaults.standard.set(currentTime, forKey: UserProfiles.OTPTime)
        }
    }
    
    func verifyOTP() {
        guard let code = code else {
            showMessage(message: "Please input OTP code")
            return
        }
        let params = [
            "otp_code" : code,
            "country_code" : countryCode!,
            "phone_number" : phoneNumber!
            ] as [String:Any]
        
        httpRequest(URLConstant.baseURL + URLConstant.verifyOTP, method: .post, parameters: params, headers: nil) { (json) in
            self.updatePassport()
        }
    }
    
    func updatePassport() {
        guard let citizenship = citizenship, let citizenshipId = citizenshipId, let passportNumber = passportNumber, let country = country, let dob = dob, let countryCode = countryCode, let phoneNumber = phoneNumber else {
            return
        }
        let params = [
            "citizenship" : citizenship,
            "citizenship_id" : citizenshipId,
            "passport_number" : passportNumber,
            "country_of_residence" : country,
            "date_of_birth": dob,
            "country_code" : countryCode,
            "phone_number" : phoneNumber
            ] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.object(forKey: UserProfiles.token) as! String
        ]
        httpUpload(endUrl: URLConstant.baseURL + URLConstant.uploadPassport, avatar: selfieImage, passport: passportImage, parameters: params, headers: headers) { json in
            UserDefaults.standard.set(self.citizenship, forKey: UserProfiles.citizenship)
            UserDefaults.standard.set(self.country, forKey: UserProfiles.country)
            UserDefaults.standard.set(self.passportNumber, forKey: UserProfiles.passportNumber)
            UserDefaults.standard.set(self.dob, forKey: UserProfiles.dateOfBirth)
            UserDefaults.standard.set(self.countryCode, forKey: UserProfiles.countryCode)
            UserDefaults.standard.set(self.phoneNumber, forKey: UserProfiles.phoneNumber)
            UserDefaults.standard.set("1", forKey: UserProfiles.passportVerified)
            self.showMessage("Thank you for updating your passport details. Please give us 3 business days to verify your account.") { _ in
                self.goBackSomeViewControllers(backNumber: 2)
            }
        }
    }
    
    //MARK: - Navigation
    override func imageButtonClick(_ sender: Any) {
        verifyOTP()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Input error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage(_ message: String, _ handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController.init(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
