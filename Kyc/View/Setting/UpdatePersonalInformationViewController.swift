//
//  UpdatePersonalInformationViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import DropDown
import DLRadioButton

class UpdatePersonalInformationViewController: UITableViewController, UITextFieldDelegate {
    let countryCodeDropDown = DropDown()
    
    //MARK: - Outlet
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var securityEnableRadioButton: DLRadioButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var currenPaswordTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBAction func selectCountryCode(_ sender: Any) {
        countryCodeDropDown.show()
    }
    
    //MARK: - Update information
    @IBAction func updatePersonalInformation(_ sender: Any) {
        if (currenPaswordTextField.text != "") {
            if (newPasswordTextField.text == "") {
                showMessage(message: "Please input new password")
                return
            } else if (newPasswordTextField.text != confirmPasswordTextField.text) {
                showMessage(message: "New passwords don't match")
                return
            }
        }
        //FIXME: Update here
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeDropDown.anchorView = countryCodeButton
        countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: countryCodeButton.bounds.height)
        countryCodeDropDown.dataSource = ["+84", "+65", "+60", "+79"]
        countryCodeDropDown.selectionAction = { [weak self] (index, item) in
            self?.countryCodeButton.setTitle(item, for: .normal)
        }
        securityEnableRadioButton.isSelected = true
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
