//
//  AgreeTermConditionViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import DLRadioButton
import LocalAuthentication

class AgreeTermConditionViewController: ParticipateCommonController{
    var project: ProjectModel?
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var termCheckbox: Checkbox!
    @IBOutlet weak var uscitizenCheckbox: Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
    }
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.setButtonTitle(title: "NEXT")
        imageButton.delegate = self
        header.setCompanyLogo(link: (project?.logo)!)
        header.setProjectTitle(title: (project?.title?.uppercased())!)
    }
    
    @IBAction func showTermsAndCoditions(_ sender: Any) {
        let dialog = TermConditionDialog("http://wpay.sg/kyc/terms.php")
        dialog.show(animated: true)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    
    override func imageButtonClick(_ sender: Any) {
        //FIXME: check selected
//        gotoNext()
        checkSelectedTermCondition()
    }
    
    //MARK: - Touch Id
    func checkSelectedTermCondition() {
        if (termCheckbox.isChecked && uscitizenCheckbox.isChecked) {
            let securityEnabled = UserDefaults.standard.string(forKey: UserProfiles.deviceSecurityEnable)!
            if (securityEnabled == "true") {
                self.authenticateUserUsingTouchId()
            } else {
                checkPassword()
            }
            
        } else {
            showMessage(message: "Please check the boxes if you accept the Terms and Conditions for this project. Otherwise, please do not participate.")
        }
    }
    
    func checkPassword() {
        let dialog = UIAlertController(title: "Password", message: "Verify with Concordia password", preferredStyle: .alert)
        dialog.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.submitPassword(dialog.textFields![0].text!)
        }))
        self.present(dialog, animated: true, completion: nil)
    }
    
    fileprivate func authenticateUserUsingTouchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Press your finger") {(success, error) in
                if (success) {
                    DispatchQueue.main.async {
                        self.gotoNext()
                    }
                } else {
                    print("You are not the owner")
                }
            }
        }
    }
    
    //MARK: - Call API
    func submitPassword(_ password: String) {
        let params = [
            "email" : UserDefaults.standard.string(forKey: UserProfiles.email)!,
            "password" : password,
            "device_id" : UserDefaults.standard.string(forKey: UserProfiles.deviceToken)!,
            "platform" : "iOS"
        ]
        httpRequest(URLConstant.baseURL + URLConstant.loginAccount, method: .post, parameters: params) { (json) in
            let user = UserModel(dictionary: json["user"] as! [String : Any])
            UserDefaults.standard.set(user.token, forKey: UserProfiles.token)
            UserDefaults.standard.set(user.securityToken, forKey: UserProfiles.securityToken)
            self.gotoNext()
        }
    }
    
    //MARK: - segue to next vc
    func gotoNext() {
       let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.WalletInputController) as! WalletInputController
        vc.project = project
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
