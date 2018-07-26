//
//  CompleteRetreivePasswordController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CompleteRetreivePasswordController: UIViewController, ImageButtonDelegate {

    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        roundView.setImage(image: #imageLiteral(resourceName: "email"))
        imageButton.setButtonTitle(title: "GO TO LOGIN PAGE")
        imageButton.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "FORGOT PASSWORD"
    }
    
    //MARK: - setup navigation bar
    func setupNavigationBar() {
        title = "FORGOT PASSWORD"
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    //MARK: - setup continue button
    func imageButtonClick(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
