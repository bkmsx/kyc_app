//
//  Checkbox.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class Checkbox: UIButton {
    var delegate: CheckboxDelegate?
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            } else {
                self.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            if (delegate != nil) {
                delegate?.changeChecked(checkbox: self)
            }
        }
    }
}

protocol CheckboxDelegate {
    func changeChecked(checkbox: Checkbox)
}
