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

class LoginViewController: UIViewController, UITextFieldDelegate, QRCodeReaderViewControllerDelegate{
    //MARK: Outlet
    var email: String = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lockImage: UIImageView!
    
    @IBAction func login(_ sender: Any) {
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
        //        getContacts()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
                        self.performSegue(withIdentifier: SegueIdentifiers.segueListProject, sender: nil)
                    }
                } else {
                    self.showMessage(message: "Invalid email or password")
                }
            case .failure:
                self.showMessage(message: "Login error")
            }
            
            
        }
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
    
    //MARK: - Prevent segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != SegueIdentifiers.segueListProject && identifier != SegueIdentifiers.segueFromLogin
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
    
    //MARK: - QR Code
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.showSwitchCameraButton = false
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func startScan() {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .currentContext
        readerVC.delegate               = self
        present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: QRCodeReader Delegates
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true){
            print("Content: \(result.value)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

