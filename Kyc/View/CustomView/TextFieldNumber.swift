//
//  TextFieldNumber.swift
//  Kyc
//
//  Created by Lai Trung Tien on 9/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TextFieldNumber: UITextField {
    override func awakeFromNib() {
        self.attributedPlaceholder = NSAttributedString.init(string: self.placeholder == nil ? "" : self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor:UIColor.gray])
        self.setBorderButtom(color: UIColor.init(argb: Colors.lightGray))
        self.backgroundColor = UIColor.clear
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(argb: Colors.lightBlue)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(hideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }

    @objc func hideKeyboard() {
        self.resignFirstResponder()
    }
}
