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

class LoginViewController: UIViewController, UITextFieldDelegate{
    //MARK: Outlet
    var email: String = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {
        gotoListProject()
        return//FIXME: Remove return
        if (emailTextField.text! == "") {
            showMessage(message: "Email is empty")
            return
        }
        if (passwordTextField.text! == "") {
            showMessage(message: "Password is empty")
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!,
            "device_id" : "121323",
            "platform" : "iOS"
        ]
        
        loginAccount(params: params)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
        return //FIXME: Remove return
        if UserDefaults.standard.object(forKey: UserProfiles.securityToken) != nil {
            if let savedEmail = UserDefaults.standard.object(forKey: UserProfiles.email) {
                email = savedEmail as! String
                emailTextField.text = email
            }
            
            if let deviceSecurityEnable = UserDefaults.standard.object(forKey: UserProfiles.deviceSecurityEnable) {
                if (deviceSecurityEnable as! String == "true") {
                    authenticateUserUsingTouchId()
                }
            }
        }
    }
    
    //MARK: - Custom Views
    func customViews() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        passwordTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
    }
    
    //MARK: - Login
    func loginAccount(params: [String: Any]) {
        Alamofire.request(URLConstant.baseURL + URLConstant.loginAccount, method: .post, parameters: params).responseJSON { response in
            switch response.result {
            case .success:
                if (response.result.value == nil) {
                    self.showMessage(message: "There is problem with network")
                    return
                }
                let json = response.result.value as! [String:Any]
                
                let resultCode = json["code"] as! Int
                if (resultCode == 200) {
                    let user = UserModel(dictionary: json["user"] as! [String : Any])
                    user.saveToLocal()
                    if (user.passportNumber == nil) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadPassportViewController") as! UploadPassportViewController
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        self.gotoListProject()
                    }
                } else {
                    self.showMessage(message: "Invalid email or password")
                }
            case .failure:
                self.showMessage(message: "Login error")
            }
            
        }
    }
    
    //MARK: - Go to List Project
    func gotoListProject() {
        //FIXME: Change viewcontroller
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ListProjectViewController)
        navigationController?.pushViewController(vc!, animated: true)
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
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: email) {(success, error) in
            if (success) {
                let parameters = [
                    "email": UserDefaults.standard.object(forKey: UserProfiles.email) as! String,
                    "security_token": UserDefaults.standard.object(forKey: UserProfiles.securityToken) as! String,
                    "device_id" : "121323",
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
    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Login error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  
}

