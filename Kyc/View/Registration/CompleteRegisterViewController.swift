//
//  SuccessRegisterViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CompleteRegisterViewController: UIViewController, ImageButtonDelegate {
    @IBOutlet weak var roundView: RoundView!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        roundView.setImage(image: #imageLiteral(resourceName: "check"))
        setupNavigationBar()
        setupContinueButton()
    }
    
    //MARK: - setup continue button
    @IBOutlet weak var imageButton: ImageButton!
    func setupContinueButton() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "GO TO LOGIN PAGE")
    }
    
    func imageButtonClick(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Hide back button
    func setupNavigationBar(){
        title = "NEW USER REGISTRATION"
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
