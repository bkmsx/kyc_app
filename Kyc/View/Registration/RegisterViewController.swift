//
//  RegisterViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import DropDown
import DLRadioButton
import Alamofire

class RegisterViewController: ParticipateCommonController {
    
    //MARK: - Properties
    let countryCodeDropDown = DropDown()
    var countryCode: String = ""
    var phoneNumber: String = ""
    
    //MARK: - Outlet
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateBirthTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmedPasswordTextField: UITextField!
    @IBOutlet weak var continueImageButton: ImageButton!
    @IBOutlet weak var radioGroup: RadioGroup!
    @IBOutlet weak var phoneCode: TextFieldPicker!
    @IBOutlet weak var referralCodeTextField: TextFieldBottomBorder!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyBoard()
    }
    
    //MARK: - Custom views
    override func customViews() {
        fillTextFields()
        continueImageButton.delegate = self
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateBirthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func fillTextFields() {
        firstNameTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempFirstName) as? String
        lastNameTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempLastName) as? String
        dateBirthTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempDateOfBirth) as? String
        emailTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempEmail) as? String
        passwordTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempPassword) as? String
        confirmedPasswordTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempPassword) as? String
        mobileTextField.text = UserDefaults.standard.object(forKey: UserProfiles.tempPhoneNumber) as? String
    }
    
    //MARK: - Validate data
    override func imageButtonClick(_ sender: Any) {
        //FIXME: uncomment validateData
//                validateData()
                gotoVerifyOTP()
    }
    
    //MARK: - Call API
    func validateData() {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let dateBirth = dateBirthTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmedPassword = confirmedPasswordTextField.text!
        let enableSecurityId = radioGroup.chooseYes()
        let referralCode = referralCodeTextField.text!
        countryCode = String((phoneCode.text?.suffix(2))!)
        phoneNumber = mobileTextField.text!
        
        if (password != confirmedPassword) {
            self.showMessage(message: "Passwords do not match")
            return
        }
        let params = [
            "first_name" : firstName,
            "last_name" : lastName,
            "date_of_birth" : dateBirth,
            "email" : email,
            "password" : password,
            "country_code" : countryCode,
            "phone_number" : phoneNumber,
            "device_security_enable" : enableSecurityId,
            "type_of_security" : "TOUCHID",
            "device_id" : "23232",
            "validation" : 1,
            "platform": "iOS"
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.register, method: .post, parameters: params, headers: nil) { _ in
            UserDefaults.standard.set(firstName, forKey: UserProfiles.tempFirstName)
            UserDefaults.standard.set(lastName, forKey: UserProfiles.tempLastName)
            UserDefaults.standard.set(dateBirth, forKey: UserProfiles.tempDateOfBirth)
            UserDefaults.standard.set(email, forKey: UserProfiles.tempEmail)
            UserDefaults.standard.set(password, forKey: UserProfiles.tempPassword)
            UserDefaults.standard.set(String(enableSecurityId), forKey: UserProfiles.tempDeviceSecurityEnable)
            UserDefaults.standard.set(self.countryCode, forKey: UserProfiles.tempCountryCode)
            UserDefaults.standard.set(self.phoneNumber, forKey: UserProfiles.tempPhoneNumber)
            UserDefaults.standard.set(referralCode, forKey: UserProfiles.tempReferralCode)
            self.sendOTPCode()
        }
    }
    
    func sendOTPCode(){
        let params = [
            "country_code" : countryCode,
            "phone_number" : phoneNumber,
            "via" : "sms"
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { _ in
            self.gotoVerifyOTP()
        }
    }
    
    //MARK: - Navigations
    func gotoVerifyOTP() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UploadPassportViewController)
        navigationController?.pushViewController(vc!, animated: true)
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
    
    //MARK: - Listen to keyboard
    func listenToKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (mobileTextField.isFirstResponder || phoneCode.isFirstResponder || referralCodeTextField.isFirstResponder) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y = -(keyboardSize.height - 100)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
