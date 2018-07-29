//
//  ForgotPasswordViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

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
        let vc = storyboard?.instantiateViewController(withIdentifier: "CompleteRetreivePasswordController")
        navigationController?.pushViewController(vc!, animated: true)
    }
}
