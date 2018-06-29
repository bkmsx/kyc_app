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

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserUsingTouchId()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    fileprivate func authenticateUserUsingTouchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            self.evaluateTouchAuthenticity(context: context)
        }
    }
    
    func evaluateTouchAuthenticity(context: LAContext) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Tien") {(success, error) in
            if (success) {
                Utilities.saveAccountDetailsToKeyChain(account: "Tien", password: "congacon")
                self.performSegue(withIdentifier: "segueListProject", sender: nil)
                print("success login")
            } else {
                print("You are not the owner")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

