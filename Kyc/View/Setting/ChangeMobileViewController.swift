//
//  ChangeMobileViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/2/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire

class ChangeMobileViewController: ParticipateCommonController {
    var countryCode: String!
    var phoneNumber: String!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var phoneCode: TextFieldPicker!
    
    //MARK: - Custom Views
    override func customViews() {
        roundView.setImage(image: #imageLiteral(resourceName: "mobile"))
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
        let regionCode = Locale.current.regionCode!
        if let index = Configs.COUNTRY_ISO.index(of: regionCode) {
            phoneCode.text = Configs.PHONE_CODES[index]
        }
    }
    
    override func imageButtonClick(_ sender: Any) {
        let text = phoneCode.text!
        let index = text.index(text.startIndex, offsetBy: 1)
        countryCode = String(text[index...])
        phoneNumber = mobileTextField.text!
        let oldPhoneNumber = UserDefaults.standard.string(forKey: UserProfiles.phoneNumber)!
        let oldCountryCode = UserDefaults.standard.string(forKey: UserProfiles.countryCode)
        if(phoneNumber == "") {
            showMessage(message: "Please input phone number")
            return
        }
        if (phoneNumber == oldPhoneNumber && oldCountryCode == countryCode) {
            showMessage(message: "New phone number should be different")
            return
        }
        self.authenticateUserUsingTouchId()
    }
    //MARK: - Touch Id
    
    fileprivate func authenticateUserUsingTouchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            self.evaluateTouchAuthenticity(context: context)
        }
    }
    
    func evaluateTouchAuthenticity(context: LAContext) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Press your finger") {(success, error) in
            if (success) {
                DispatchQueue.main.async {
                    self.requestOTP()
                }
            } else {
                print("You are not the owner")
            }
        }
    }
    
    //MARK: - Call API
    func requestOTP() {
        let params: [String : Any] = [
            "country_code" : countryCode!,
            "phone_number" : phoneNumber!,
            "via" : "sms"
            ]
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { _ in
            self.gotoOTPVerification()
        }
    }
    
    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    func gotoOTPVerification() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.OTPUpdateMobileViewController) as! OTPUpdateMobileViewController
        vc.countryCode = countryCode
        vc.phoneNumber = phoneNumber
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Input error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
