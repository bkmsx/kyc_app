//
//  UpdatePersonalInformationViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class UpdatePersonalInformationViewController: ParticipateCommonController, UITextFieldDelegate{
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var dropDownButton: DropDownButton!
    @IBOutlet weak var mobilePhone: UITextField!
    @IBOutlet weak var dateBirthTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmedPasswordTextField: UITextField!
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
        setupTextField()
        setupDropdown()
    }
    //MARK: - Setup Navigation Bar
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }

    //MARK: - Setup TextField
    func setupTextField() {
        mobilePhone.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        dateBirthTextField.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        currentPasswordTextField.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        newPasswordTextField.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        confirmedPasswordTextField.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        
        mobilePhone.text = UserDefaults.standard.string(forKey: UserProfiles.phoneNumber)
        dateBirthTextField.text = UserDefaults.standard.string(forKey: UserProfiles.dateOfBirth)
    }
    //MARK: - Setup Dropdown
    func setupDropdown() {
        dropDownButton.setDataSource(source: Configs.PHONE_CODES)
        dropDownButton.setTextMarginLeft(value: 15)
    }
    
    //MARK: - Update
    override func imageButtonClick(_ sender: Any) {
       
        if (currentPasswordTextField.text != "") {
            if (newPasswordTextField.text == "") {
                showMessage(message: "Please input new password")
                return
            } else if (newPasswordTextField.text != confirmedPasswordTextField.text) {
                showMessage(message: "New passwords don't match")
                return
            }
        }
        let params = [
            "old_password" : currentPasswordTextField.text!,
            "password" : newPasswordTextField.text!
            ]
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        //FIXME: Update here
        Alamofire.request(URLConstant.baseURL + URLConstant.changePassword, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            self.goBack()
        }
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
