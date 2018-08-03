//
//  ConfigurationViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/3/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ConfigurationViewController: ParticipateCommonController {
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var radioGroup: RadioGroup!
    @IBOutlet weak var imageButton: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func customViews() {
        roundView.setImage(image: #imageLiteral(resourceName: "setting"))
        imageButton.setButtonTitle(title: "UPDATE")
        imageButton.delegate = self
    }
    
    override func imageButtonClick(_ sender: Any) {
        goBack()
    }

    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
}
