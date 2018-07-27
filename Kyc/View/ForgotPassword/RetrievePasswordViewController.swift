//
//  ForgotPasswordViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class RetrievePasswordViewController: UIViewController, ImageButtonDelegate {

    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var continueButton: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       continueButton.delegate = self
        mailTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightGray))
        roundView.setImage(image: #imageLiteral(resourceName: "email"))
        continueButton.setButtonTitle(title: "RETRIEVE PASSWORD")
        setupNavigationBar()
    }
    
    //MARK: - setup navigation bar
    func setupNavigationBar() {
        title = "FORGOT PASSWORD"
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]
    }

    //MARK: - setup continue button
    func imageButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CompleteRetreivePasswordController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}