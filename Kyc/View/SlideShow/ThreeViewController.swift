//
//  ThreeViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ThreeViewController: UIViewController {

    @IBOutlet weak var slideIndicator: SlideIndicator!
    override func viewDidLoad() {
        super.viewDidLoad()
        slideIndicator.setIndicator(2)
    }

}
