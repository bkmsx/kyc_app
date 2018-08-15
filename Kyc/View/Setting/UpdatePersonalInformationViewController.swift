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
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmedPasswordTextField: UITextField!
    @IBOutlet weak var roundView: RoundView!
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
        roundView.setImage(image: #imageLiteral(resourceName: "lock"))
    }
    
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
        updatePassword()
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    func logout() {
        UserModel.removeFromLocal()
        let nav = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginNavigationController)
        navigationController?.present(nav!, animated: true, completion: nil)
    }
    
    
    //MARK: - Call API
    func updatePassword() {
        let params = [
            "old_password" : currentPasswordTextField.text!,
            "password" : newPasswordTextField.text!
        ]
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        //FIXME: Update here
        httpRequest(URLConstant.baseURL + URLConstant.changePassword, method: .post, parameters: params, headers: headers) { _ in
            self.makeToast("Password has changed")
            self.logout()
        }
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
