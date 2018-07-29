//
//  CompleteRetreivePasswordController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CompleteRetreivePasswordController: ParticipateCommonController {

    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundView.setImage(image: #imageLiteral(resourceName: "email"))
        imageButton.setButtonTitle(title: "GO TO LOGIN PAGE")
        imageButton.delegate = self
    }
    
    //MARK: - setup continue button
    override func imageButtonClick(_ sender: Any) {
        goBackRootView()
    }
    
}
