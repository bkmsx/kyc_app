//
//  UpdatePersonalInformationViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class UpdatePersonalInformationViewController: ParticipateCommonController, UITextFieldDelegate{
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var dropDownButton: DropDownButton!
    @IBOutlet weak var mobilePhone: UITextField!
    
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
        mobilePhone.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        setupDropdown()
    }
    
    //MARK: - Setup Dropdown
    func setupDropdown() {
        dropDownButton.setDataSource(source: ["+65", "+84", "+79"])
        dropDownButton.setTextMarginLeft(value: 15)
    }
    
    //MARK: - Update
    override func imageButtonClick(_ sender: Any) {
       
//        if (currenPaswordTextField.text != "") {
//            if (newPasswordTextField.text == "") {
//                showMessage(message: "Please input new password")
//                return
//            } else if (newPasswordTextField.text != confirmPasswordTextField.text) {
//                showMessage(message: "New passwords don't match")
//                return
//            }
//        }
        //FIXME: Update here
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    //MARK: - Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
