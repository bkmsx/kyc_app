//
//  ProjectDetailViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ProjectDetailViewController: ParticipateCommonController {

    @IBOutlet weak var companyLogo: UIView!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Custom views
    override func customViews() {
        companyLogo.layer.cornerRadius = 10
        participateButton.layer.cornerRadius = participateButton.frame.size.height / 2
        inviteButton.layer.cornerRadius = inviteButton.frame.size.height / 2
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
}
