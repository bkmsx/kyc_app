//
//  TransactionDetailController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TransactionDetailController: ParticipateCommonController {
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SUBMIT")
        header.setSelectIndicator(index: 2)
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }
    
    //MARK: - Go to next
    func gotoNext() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SuccessTransactionViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
}
