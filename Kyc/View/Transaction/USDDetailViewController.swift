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
    
    @IBOutlet weak var imageButton: ImageButton!
    
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
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
    }
    
    override func imageButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.InvitationInforController) as! InvitationInforController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        goBackRootView()
    }
}
