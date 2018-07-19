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

class AgreeTermConditionViewController: UIViewController {

    @IBOutlet weak var acceptTerm: DLRadioButton!
    @IBOutlet weak var notUSCitizen: DLRadioButton!
    
    @IBAction func gotoNext(_ sender: Any) {
        if (acceptTerm.isSelected && notUSCitizen.isSelected) {
            self.authenticateUserUsingTouchId()
        } else {
            showMessage(message: "Please select checkboxes to agree with terms and condition")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptTerm.isMultipleSelectionEnabled = true;
    }
    
    //MARK: - Touch Id
    fileprivate func authenticateUserUsingTouchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            self.evaluateTouchAuthenticity(context: context)
        }
    }
    
    func evaluateTouchAuthenticity(context: LAContext) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Press your finger") {(success, error) in
            if (success) {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifiers.segueERC20Wallet, sender: nil)
                }
            } else {
                print("You are not the owner")
            }
        }
    }
    
    
    //MARK: - Prevent segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != SegueIdentifiers.segueERC20Wallet
    }
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
