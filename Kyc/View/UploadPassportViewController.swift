//
//  UploadPassportViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import DropDown
import DLRadioButton

class UploadPassportViewController: UIViewController {

    @IBOutlet weak var btnSelectCitizenship: UIButton!
    
    @IBOutlet weak var accuracySelection: DLRadioButton!
    
    @IBAction func selectCitizenship(_ sender: Any) {
        citizenshipDropDown.show()
    }
    
    @IBAction func selectCheckbox(_ sender: Any) {
    }
    
    
    let citizenshipDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
        accuracySelection.isMultipleSelectionEnabled = true
    }

    func setupDropDown(){
        citizenshipDropDown.anchorView = btnSelectCitizenship
        citizenshipDropDown.bottomOffset = CGPoint.init(x: 0, y: btnSelectCitizenship.bounds.height)
        citizenshipDropDown.selectionAction = { [weak self](index, item) in
            self?.btnSelectCitizenship.setTitle(item, for: .normal)
            
        }
        
        citizenshipDropDown.dataSource = [
        "Singapore", "VietNamese", "ThaiLand", "Malaysia"
        ]
    }
}
