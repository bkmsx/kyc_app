//
//  VerifyOTPViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class VerifyOTPViewController: ParticipateCommonController, UITextFieldDelegate,  CodeInputViewDelegate {
    //MARK: - Properties
    var code = ""
    //MARK: - Outlet
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueImageButton: ImageButton!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        continueImageButton.delegate = self
        setupOTPInput()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - Setup OTP input
    func setupOTPInput() {
        let OTPWidth = Int(CodeInputView.OTP_LENGTH * CodeInputView.NUMBER_WIDTH + CodeInputView.NUMBER_SPACE)
        let frame = CGRect(x: (Int(view.frame.width) - OTPWidth) / 2, y: 242, width: OTPWidth, height: CodeInputView.INPUT_HEIGHT)
        let codeInputView = CodeInputView(frame: frame)
        codeInputView.delegate = self
        view.addSubview(codeInputView)
        codeInputView.becomeFirstResponder()
    }

    //MARK: - Verify OTP
    
    func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String) {
        self.code = code
    }
    
    override func imageButtonClick(_ sender: Any) {
        //FIXME: uncomment verify
//        verifyOTP()
        gotoUploadPassport()
    }
    
    func verifyOTP() {
        let countryCode = UserDefaults.standard.object(forKey: UserProfiles.tempCountryCode)!
        let phoneNumber = UserDefaults.standard.object(forKey: UserProfiles.tempPhoneNumber)!
        let params = [
            "otp_code" : code,
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
    
    //MARK: - Resend OTP
    @IBAction func resendOTP(_ sender: Any) {
        //TODO: - ResendOTP
    }
    
    
    //MARK: - Success verify OTP
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
    
    func gotoUploadPassport() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UploadPassportViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Dialog
    func showMessage(message: String, buttonName: String, handler:((UIAlertAction) -> Swift.Void)?=nil) {
        let alert = UIAlertController.init(title: "Verify OTP", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: buttonName, style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
