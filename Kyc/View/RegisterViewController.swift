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

class RegisterViewController: UITableViewController {
    
    let countryCodeDropDown = DropDown()
    var countryCode: String = ""
    var phoneNumber: String = ""
    
    @IBOutlet weak var btnCountryCode: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateBirthTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmedPasswordTextField: UITextField!
    @IBOutlet weak var noRadio: DLRadioButton!
    @IBOutlet weak var erc20AddressTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func selectCountryCode(_ sender: Any) {
        countryCodeDropDown.show()
    }
    
    @IBAction func `continue`(_ sender: Any) {
//        gotoVerifyOTP()
        validateData()
//        sendOTPCode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg-subtle"));
        setupDropDown()
        noRadio.isSelected = true
    }
    
    func setupDropDown() {
        countryCodeDropDown.anchorView = btnCountryCode
        countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: btnCountryCode.bounds.height)
        countryCodeDropDown.dataSource = [
            "+84", "+65", "+60", "+79"
        ]
        countryCodeDropDown.selectionAction = { [weak self] (index, item) in
                self?.btnCountryCode.setTitle(item, for: .normal)
        }
    }
    
    func validateData() {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let dateBirth = dateBirthTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmedPassword = confirmedPasswordTextField.text!
        let erc20Address = erc20AddressTextField.text!
        let enableSecurityId = !noRadio.isSelected
        countryCode = String(btnCountryCode.currentTitle!.suffix(2))
        phoneNumber = mobileTextField.text!
        UserDefaults.standard.set(firstName, forKey: UserProfiles.firstName)
        UserDefaults.standard.set(lastName, forKey: UserProfiles.lastName)
        UserDefaults.standard.set(dateBirth, forKey: UserProfiles.dateOfBirth)
        UserDefaults.standard.set(email, forKey: UserProfiles.email)
        UserDefaults.standard.set(password, forKey: UserProfiles.password)
        UserDefaults.standard.set(erc20Address, forKey: UserProfiles.erc20Address)
        UserDefaults.standard.set(String(enableSecurityId), forKey: UserProfiles.deviceSecurityEnable)
        UserDefaults.standard.set(countryCode, forKey: UserProfiles.countryCode)
        UserDefaults.standard.set(phoneNumber, forKey: UserProfiles.phoneNumber)
        
        if (password != confirmedPassword) {
            self.showMessage(message: "Passwords are not matched")
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
            "erc20_address" : erc20Address,
            "device_id" : "23232",
            "validation" : 1,
            "platform": "iOS"
            ] as [String : Any]
        activityIndicator.startAnimating()
        Alamofire.request(URLConstant.baseURL + URLConstant.register, method: .post, parameters: params)
            .responseJSON{ response in
                let JSON = response.result.value as! NSDictionary
                let responseCode = JSON["code"] as! Int
                if (responseCode == 404) {
                    let message = JSON["message"] as! String
                    self.showMessage(message: message)
                    self.activityIndicator.stopAnimating()
                } else {
                    self.sendOTPCode()
                }
        }
    }
    
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Input error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendOTPCode(){
        let params = [
            "country_code" : countryCode,
            "phone_number" : phoneNumber,
            "via" : "sms"
            ] as [String : Any]
        Alamofire.request(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params)
            .responseJSON{ response in
                self.activityIndicator.stopAnimating()
                self.gotoVerifyOTP()
        }
    }
    
    func gotoVerifyOTP() {
        performSegue(withIdentifier: "segueVerifyOTP", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != "segueVerifyOTP"
    }

}
