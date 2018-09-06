//
//  ForgotPasswordViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class RetrievePasswordViewController: ParticipateCommonController{

    
    @IBOutlet weak var mailTextField: TextFieldBottomBorder!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var continueButton: ImageButton!
    
    //MARK: - Custom views
    override func customViews() {
        continueButton.delegate = self
        roundView.setImage(image: #imageLiteral(resourceName: "email"))
        continueButton.setButtonTitle(title: "RETRIEVE PASSWORD")
    }
    
    //MARK: - Events
    override func imageButtonClick(_ sender: Any) {
        retrievePassword()
    }
    
    //MARK: - Call API
    func retrievePassword() {
        let params = [
            "email" : mailTextField.text!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.resetPassword, method: .post, parameters: params, headers: nil) { _ in
            self.gotoNext()
        }
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    func gotoNext() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.CompleteRetreivePasswordController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
