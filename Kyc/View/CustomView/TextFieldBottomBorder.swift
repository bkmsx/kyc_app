//
//  TextFieldBottomBorder.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/11/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TextFieldBottomBorder: UITextField {

    override func awakeFromNib() {
        self.attributedPlaceholder = NSAttributedString.init(string: self.placeholder == nil ? "" : self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor:UIColor.gray])
        self.setBorderButtom(color: UIColor.init(argb: Colors.lightGray))
        self.backgroundColor = UIColor.clear
    }
}
