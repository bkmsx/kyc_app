//
//  TextFieldPicker.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/10/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TextFieldPicker: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var useKeyBoard = true
    var customButton: UIBarButtonItem?
    var pickerView: UIPickerView?
    var data = [String]()
    
    override func awakeFromNib() {
       createPickerView()
    }
    
    func createPickerView() {
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        self.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(argb: Colors.lightBlue)
        toolBar.sizeToFit()
        customButton = UIBarButtonItem(title: "Keyboard", style: UIBarButtonItemStyle.plain, target: self, action:#selector(showKeyboard))
        toolBar.setItems([customButton!], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
        data = Configs.NICE_CODES
    }
    
    @objc func showKeyboard() {
        if (useKeyBoard) {
            useKeyBoard = false
            self.inputView = nil
            self.keyboardAppearance = UIKeyboardAppearance.default
            self.keyboardType = UIKeyboardType.phonePad
            self.customButton?.title = "Selection"
            self.reloadInputViews()
        } else {
            useKeyBoard = true
            self.inputView = pickerView
            self.reloadInputViews()
            self.customButton?.title = "Keyboard"
            self.becomeFirstResponder()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = Configs.PHONE_CODES[row]
    }
}
