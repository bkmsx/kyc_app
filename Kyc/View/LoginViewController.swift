//
//  ViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/27/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func login(_ sender: Any) {
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!,
            "device_id" : "121323",
            "platform" : "iOS"
        ]
        
        loginAccout(params: params)
    }
    
    var email: String = ""
    
    func loginAccout(params: [String: Any]) {
        Alamofire.request(URLConstant.baseURL + URLConstant.loginAccount, method: .post, parameters: params).responseJSON { response in
            if (response.result.value == nil) {
                self.showMessage(message: "There is problem with network")
                return
            }
            let json = response.result.value as! [String:Any]
            
            let resultCode = json["code"] as! Int
            if (resultCode == 200) {
                let user = UserModel(dictionary: json["user"] as! [String : Any])
                user.saveToLocal()
                self.performSegue(withIdentifier: SegueIdentifiers.segueListProject, sender: nil)
            } else {
                self.showMessage(message: "Invalid email or password")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedEmail = UserDefaults.standard.object(forKey: UserProfiles.email) {
            email = savedEmail as! String
            emailTextField.text = email
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        if let deviceSecurityEnable = UserDefaults.standard.object(forKey: UserProfiles.deviceSecurityEnable) {
            if (deviceSecurityEnable as! String == "true") {
                authenticateUserUsingTouchId()
            }
        }
    }
    
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Login error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func authenticateUserUsingTouchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            self.evaluateTouchAuthenticity(context: context)
        }
    }
    
    func evaluateTouchAuthenticity(context: LAContext) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: email) {(success, error) in
            if (success) {
                let parameters = [
                    "email": UserDefaults.standard.object(forKey: UserProfiles.email) as! String,
                    "security_token": UserDefaults.standard.object(forKey: UserProfiles.securityToken) as! String,
                    "device_id" : "121323",
                    "platform" : "iOS"
                ]
                self.loginAccout(params: parameters)
            } else {
                print("You are not the owner")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != SegueIdentifiers.segueListProject
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

