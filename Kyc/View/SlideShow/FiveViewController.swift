//
//  FiveViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class FiveViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var slideIndicator: SlideIndicator!
    override func viewDidLoad() {
        super.viewDidLoad()
        slideIndicator.setIndicator(4)
        signupButton.layer.cornerRadius = signupButton.frame.height / 2
    }

    @IBAction func gotoSignup(_ sender: Any) {
        let signupVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.RegisterViewController)
        let loginVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginViewController)
        let navigationController = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginNavigationController) as! UINavigationController
        navigationController.viewControllers = [loginVC, signupVC] as! [UIViewController]
        present(navigationController, animated: true, completion: nil)
    }
}
