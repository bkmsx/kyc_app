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
import Contacts

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
    
    var email: String = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != SegueIdentifiers.segueListProject && identifier != SegueIdentifiers.segueFromLogin
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getContacts(){
        let contactStore = CNContactStore()
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey
        ] as [Any]
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        var results: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keyToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        for contact in results {
            var name_phone = ""
            if (!contact.givenName.isEmpty) {
                name_phone.append(contact.givenName)
                name_phone.append(" ")
            }
            if (!contact.familyName.isEmpty) {
                name_phone.append(contact.familyName)
            }
            if (contact.phoneNumbers.count > 0) {
                name_phone.append(": ")
                name_phone.append(contact.phoneNumbers[0].value.stringValue)
                print(name_phone)
            }
        }
    }
}

