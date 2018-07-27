//
//  RadioGroup.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/27/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class RadioGroup: UIView, CheckboxDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var yesRadio: Checkbox!
    @IBOutlet weak var noRadio: Checkbox!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RadioGroup", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        yesRadio.isChecked = true
        yesRadio.delegate = self
        noRadio.delegate = self
    }
    
    
    func changeChecked(checkbox: Checkbox) {
        if (checkbox == yesRadio) {
            noRadio.isChecked = !noRadio.isChecked
        } else {
            yesRadio.isChecked = !yesRadio.isChecked
        }
    }
}
