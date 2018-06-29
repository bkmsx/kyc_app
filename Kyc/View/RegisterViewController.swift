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
    
    @IBAction func selectCountryCode(_ sender: Any) {
        countryCodeDropDown.show()
    }
    
    @IBAction func `continue`(_ sender: Any) {
//        validateData()
        sendOTPCode()
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
        let enableSecurityId = noRadio.isSelected
        print(enableSecurityId)
//        Alamofire.request(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params)
//            .responseJSON{ response in
//                
//        }
    }
    
    func sendOTPCode(){
        let countryCode = btnCountryCode.currentTitle!.suffix(2)
        let mobile = mobileTextField.text!
        UserDefaults.standard.set(countryCode, forKey: UserProfiles.countryCode)
        UserDefaults.standard.set(mobile, forKey: UserProfiles.phoneNumber)
        
        let params = [
            "country_code" : countryCode,
            "phone_number" : mobile,
            "via" : "sms"
            ] as [String : Any]
        Alamofire.request(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params)
            .responseJSON{ response in
                
        }
    }

}
