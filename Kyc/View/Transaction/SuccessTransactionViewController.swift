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
    var paymentMethod: PaymentMethodModel?
    var amount: String?
    
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var tokenNumberLabel: ColorLabel!
    @IBOutlet weak var shareLabel: ColorLabel!
    
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
        if let paymentMethod = paymentMethod {
            copyLabel.setText(text: paymentMethod.walletAddress!)
            qrImageView.image = generateQRCode(from: paymentMethod.walletAddress!)
        }
        
        
        tokenNumberLabel.setTextColor(shortText: "W Green Pay tokens", color: UIColor.white)
        if let amount = amount, let paymentMethod = paymentMethod {
            tokenNumberLabel.text = "You are approved to purchase W Green Pay tokens. Please send your " + amount + " " + paymentMethod.methodName! + " to this address below"
            tokenNumberLabel.setTextColor(shortText: amount + " " + paymentMethod.methodName!, color: UIColor.white)
        } else {
            tokenNumberLabel.setTextColor(shortText: "0 ETHER", color: UIColor.white)
        }
        shareLabel.setTextColor(shortText: "GET 10 FREE TOKENS", color: UIColor.white)
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }
    
    //MARK: - Navigations
    func gotoNext() {
        guard project?.isPromoted == 1 else {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ChooseShareMethodViewController) as! ChooseShareMethodViewController
            vc.projectName = project?.title
            navigationController?.pushViewController(vc, animated: true)
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
