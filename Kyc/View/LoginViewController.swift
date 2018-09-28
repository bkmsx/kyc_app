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

import AVFoundation
import QRCodeReader

class LoginViewController: ParticipateCommonController {
    //MARK: Outlet
    var email: String = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {

        if (emailTextField.text! == "") {
            showMessage(message: "Email is empty")
            return
        }
        if (passwordTextField.text! == "") {
            showMessage(message: "Password is empty")
            return
        }
        let deviceToken = UserDefaults.standard.string(forKey: UserProfiles.deviceToken)
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!,
            "device_id" : deviceToken != nil ? deviceToken! : "1234" ,
            "platform" : "iOS"
        ]
        
        loginAccount(params: params)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//                let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ProjectDetailViewController)

//                navigationController?.pushViewController(vc!, animated: true)
//                return //FIXME: remove return
        if UserDefaults.standard.object(forKey: UserProfiles.securityToken) != nil {
            if let savedEmail = UserDefaults.standard.object(forKey: UserProfiles.email) {
                email = savedEmail as! String
                emailTextField.text = email
            }
            
            if let deviceSecurityEnable = UserDefaults.standard.object(forKey: UserProfiles.deviceSecurityEnable) as? String, deviceSecurityEnable == "true" {

                authenticateUserUsingTouchId()
                
            }
        }
    }
    
    //MARK: - Custom Views
    override func customViews() {
        emailTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        passwordTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
    }
    
    //MARK: - Login
    func loginAccount(params: [String: Any]) {
        httpRequest(URLConstant.baseURL + URLConstant.loginAccount, method: .post, parameters: params, headers: nil) { (json) in
            let user = UserModel(dictionary: json["user"] as! [String : Any])
            user.saveToLocal()
            if (user.citizenship == nil) {
                self.gotoUploadPassport()
            } else {
                self.gotoListProject()
            }
        }
    }
    
    //MARK: - Navigations
    func gotoListProject() {
        //FIXME: Change viewcontroller
        let nav = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ProjectNavigationController)
        navigationController?.present(nav!, animated: true, completion: nil)
    }
    
    func gotoUploadPassport() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UploadPassportViewController) as! UploadPassportViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Touch Id
    fileprivate func authenticateUserUsingTouchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            self.evaluateTouchAuthenticity(context: context)
        }
    }
    
    func evaluateTouchAuthenticity(context: LAContext) {
        if (email.isEmpty) {
            email = "Press your imprint"
        }
        let deviceToken = UserDefaults.standard.string(forKey: UserProfiles.deviceToken)
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: email) {(success, error) in
            if (success) {
                let parameters = [
                    "email": UserDefaults.standard.object(forKey: UserProfiles.email) as! String,
                    "security_token": UserDefaults.standard.object(forKey: UserProfiles.securityToken) as! String,
                    "device_id" : deviceToken != nil ? deviceToken! : "1234" ,
                    "platform" : "iOS"
                ]
                self.loginAccount(params: parameters)
            } else {
                print("You are not the owner")
            }
        }
    }
    
    //MARK: - Hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Login error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

