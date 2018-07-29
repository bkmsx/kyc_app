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
    @IBOutlet weak var tokenNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SUBMIT")
        header.setSelectIndicator(index: 2)
        tokenNumber.layer.cornerRadius = tokenNumber.frame.size.height / 2
        tokenNumber.layer.borderWidth = 1
        tokenNumber.layer.borderColor = UIColor.init(argb: Colors.lightBlue).cgColor
    }
    @IBAction func clickBack(_ sender: Any) {
        goBack()
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
