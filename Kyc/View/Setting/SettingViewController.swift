//
//  SettingViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    @IBAction func logOut(_ sender: Any) {
        UserModel.removeFromLocal()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
