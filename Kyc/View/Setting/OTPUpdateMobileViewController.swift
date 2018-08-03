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

class OTPUpdateMobileViewController: ParticipateCommonController, CodeInputViewDelegate {
    var countryCode: String?
    var phoneNumber: String?
    var code: String?
    @IBOutlet weak var imageButton: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
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
    //MARK: - Resend OTP
    @IBAction func resendOTP(_ sender: Any) {
        let params = [
            "country_code" : countryCode!,
            "phone_number" : phoneNumber!,
            "via" : "sms"
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { (json) in
            self.activityIndicatorView?.stopAnimating()
            self.view.makeToast("Resent OTP code")
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
            self.submitPhoneNumber()
        }
    }
    
    //MARK: - Submit phone number
    func submitPhoneNumber() {
        goBackSomeViewControllers(backNumber: 2)
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
}
