//
//  SelectAll.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/14/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SelectAll: UIView, CheckboxDelegate {
    var delegate: SelectAllDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var selectAllCheckbox: Checkbox!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SelectAll", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        selectAllCheckbox.isChecked = false
        selectAllCheckbox.delegate = self
    }
    
    func changeChecked(checkbox: Checkbox) {
        if let delegate = delegate {
            delegate.toggleSellectAll(checkbox.isChecked)
        }
    }
    
    func setChecked(_ checked: Bool) {
        selectAllCheckbox.isChecked = checked
    }
    
}

protocol SelectAllDelegate {
    func toggleSellectAll(_ select: Bool)
}
