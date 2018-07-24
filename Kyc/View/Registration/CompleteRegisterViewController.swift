//
//  SuccessRegisterViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CompleteRegisterViewController: UIViewController {

    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
