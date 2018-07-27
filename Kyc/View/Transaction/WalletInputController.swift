//
//  WalletInputController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class WalletInputController: ParticipateCommonController {

    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var walletAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "NEXT")
        header.setSelectIndicator(index: 1)
        roundView.setImage(image: #imageLiteral(resourceName: "check"))
        walletAddress.layer.cornerRadius = walletAddress.frame.size.height / 2
        walletAddress.clipsToBounds = true
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }

    //MARK: - Goto next
    func gotoNext(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TransactionDetailController")
        navigationController?.pushViewController(vc!, animated: true)
    }
}
