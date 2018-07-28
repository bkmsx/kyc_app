//
//  PhoneCell.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class PhoneCell: UITableViewCell, CheckboxDelegate {
    
    @IBOutlet weak var contactCheckbox: Checkbox!
    @IBOutlet weak var contactLabel: UILabel!
    var delegate: PhoneCellDelegate?
    var contact: ContactModel? {
        didSet {
            contactLabel.text = contact?.contactName
        }
    }
    override func awakeFromNib() {
        contactCheckbox.delegate = self
    }
    
    func changeChecked(checkbox: Checkbox) {
        if (delegate != nil) {
            delegate?.changeChecked(contact: contact!, isChecked: checkbox.isChecked)
        }
    }
}

protocol PhoneCellDelegate {
    func changeChecked(contact: ContactModel, isChecked: Bool)
}
