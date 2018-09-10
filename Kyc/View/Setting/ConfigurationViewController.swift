//
//  ConfigurationViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/3/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import LocalAuthentication

class ConfigurationViewController: ParticipateCommonController {
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var radioGroup: RadioGroup!
    @IBOutlet weak var imageButton: ImageButton!
    var oldCheck: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Custom views
    override func customViews() {
        roundView.setImage(image: #imageLiteral(resourceName: "setting"))
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
        oldCheck = UserDefaults.standard.string(forKey: UserProfiles.deviceSecurityEnable) == "true" ? true : false
        radioGroup.setYes(oldCheck)
    }
    
    //MARK: - Events
    override func imageButtonClick(_ sender: Any) {
        if (radioGroup.chooseYes() != oldCheck){
            authenticateUserUsingTouchId()
        } else {
            showMessages("No update is performed as no setting was changed.")
        }
    }
    
    //MARK: - Touch ID
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
                    self.updateTouchIdEnable()
                }
            } else {
                DispatchQueue.main.async {
                    self.showMessages("You are not the owner")
                }
            }
        }
    }
    
    //MARK: - Call API
    func updateTouchIdEnable() {
        let params = [
            "device_security_enable" : String(radioGroup.chooseYes())
            ] as [String:Any]
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.updateUserInfor, method: .post, parameters: params, headers: headers) { _ in
            UserDefaults.standard.set(String(self.radioGroup.chooseYes()), forKey: UserProfiles.deviceSecurityEnable)
            self.goBack()
        }
    }

    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
}
