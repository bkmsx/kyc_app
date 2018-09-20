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
    var paymentMethod: PaymentMethodModel?
    var amount: String?
    
    @IBOutlet weak var participateHeader: ParticipateHeader!
    @IBOutlet weak var bankDetailBackground: UIView!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var swiftCode: UILabel!
    @IBOutlet weak var bankAddress: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var usdAmount: ColorLabel!
    
    //MARK: - Custom Views
    override func customViews() {
        bankDetailBackground.layer.cornerRadius = 10
        bankDetailBackground.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        participateHeader.setSelectIndicator(index: 3)
        
        if let project = project {
            participateHeader.setProjectTitle(title: project.title!)
            participateHeader.setCompanyLogo(link: project.logo!)
        }
        if let amount = amount {
            usdAmount.text = "You are approved to purchase W Green Pay tokens. Please send your " + amount + " USD to this address below"
            usdAmount.setTextColor(shortText: amount + " USD", color: UIColor.white)
        }
        if let paymentMethod = paymentMethod {
            bankName.text = paymentMethod.bankName
            swiftCode.text = paymentMethod.swiftCode
            bankAddress.text = paymentMethod.bankAddress
            accountName.text = paymentMethod.accountName
            accountNumber.text = paymentMethod.accountNumber
            businessAddress.text = paymentMethod.holderAddress
        }
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
    }
    
    override func imageButtonClick(_ sender: Any) {
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
    
    @IBAction func clickDone(_ sender: Any) {
        goBackRootView()
    }
}
