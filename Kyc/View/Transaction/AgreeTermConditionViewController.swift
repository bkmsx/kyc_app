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
            self.authenticateUserUsingTouchId()
        } else {
            showMessage(message: "Please select checkboxes to agree with terms and condition")
        }
    }
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
                    self.gotoNext()
                }
            } else {
                print("You are not the owner")
            }
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
