//
//  SuccessTransactionViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SuccessTransactionViewController: ParticipateCommonController {
    var project: ProjectModel?
    let walletAddress = "0xFAF31560d94E7dDE9098dC99B3419b927b87bC4F"
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var tokenNumberLabel: ColorLabel!
    @IBOutlet weak var shareLabel: ColorLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageView.image = generateQRCode(from: walletAddress)
    }
    
    //MARK: - Custom views
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var copyLabel: CopyLabel!
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
        header.setSelectIndicator(index: 3)
        if let project = project {
            header.setCompanyLogo(link: (project.logo)!)
            header.setProjectTitle(title: (project.title?.uppercased())!)
        }
        copyLabel.setText(text: walletAddress)
        
        tokenNumberLabel.setTextColor(shortText: "W Green Pay tokens", color: UIColor.white)
        tokenNumberLabel.setTextColor(shortText: "10 ETHER", color: UIColor.white)
        shareLabel.setTextColor(shortText: "GET 10 FREE TOKENS", color: UIColor.white)
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }
    
    //MARK: - Navigations
    func gotoNext() {
        guard project?.isPromoted == 1 else {
            showMessages("This project is not promoted")
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.InvitationInforController) as! InvitationInforController
        vc.projectId = project?.projectId
        vc.projectName = project?.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToProjectList(_ sender: Any) {
        goBackRootView()
    }
    
    
    
}
