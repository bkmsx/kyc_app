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
    @IBOutlet weak var dropdownButton: DropDownButton!
    @IBOutlet weak var imageButton: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Custom Views
    override func customViews() {
        roundView.setImage(image: #imageLiteral(resourceName: "mobile"))
        mobileTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightGray))
        dropdownButton.setDataSource(source: Configs.PHONE_CODES)
        dropdownButton.setTextMarginLeft(value: 10)
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
        
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
    
    //MARK: - Request OTP
    func requestOTP() {
        let text = dropdownButton.text
        let index = text.index(text.startIndex, offsetBy: 1)
        countryCode = String(dropdownButton.text[index...])
        phoneNumber = mobileTextField.text!
        
        let params = [
            "country_code" : countryCode,
            "phone_number" : phoneNumber,
            "via" : "sms"
            ] as [String : Any]
        activityIndicatorView?.startAnimating()
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { (json) in
            self.activityIndicatorView?.stopAnimating()
            self.gotoOTPVerification()
        }
    }
    
    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        self.authenticateUserUsingTouchId()
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