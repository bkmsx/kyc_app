//
//  CommonViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
    }
    
    func customViews() {
        
    }

    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
