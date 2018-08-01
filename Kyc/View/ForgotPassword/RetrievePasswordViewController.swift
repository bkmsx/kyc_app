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

    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var continueButton: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       continueButton.delegate = self
        mailTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightGray))
        roundView.setImage(image: #imageLiteral(resourceName: "email"))
        continueButton.setButtonTitle(title: "RETRIEVE PASSWORD")
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - setup continue button
    override func imageButtonClick(_ sender: Any) {
        let params = [
            "email" : mailTextField.text!
        ]
        Alamofire.request(URLConstant.baseURL + URLConstant.resetPassword, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {response in
            let json = response.result.value as! [String:Any]
            let code = json["code"] as! Int
            if (code == 200) {
                self.gotoNext()
            } else {
                self.showMessage(message: json["message"] as! String)
            }
        }
    }
    
    //MARK: - Go to Next
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
