//
//  USDDetailViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/2/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class USDDetailViewController: ParticipateCommonController {
    var project: ProjectModel?
    @IBOutlet weak var participateHeader: ParticipateHeader!
    @IBOutlet weak var bankDetailBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Custom Views
    override func customViews() {
        bankDetailBackground.layer.cornerRadius = 10
        bankDetailBackground.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        participateHeader.setSelectIndicator(index: 3)
        
        if let project = project {
            participateHeader.setProjectTitle(title: project.title!)
            participateHeader.setCompanyLogo(link: project.logo!)
        }
    }
    
    @IBAction func clickDone(_ sender: Any) {
        goBackRootView()
    }
}
