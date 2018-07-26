//
//  ParticipateCommonController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ParticipateCommonController: CommonViewController, ImageButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - setup navigation bar
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]
        
    }
    
    func imageButtonClick(_ sender: Any) {
        
    }
}
