//
//  SettingRow.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/27/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SettingRow: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SettingRow", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
    var delegate: SettingRowDelegate?
    @IBAction func clickButton(_ sender: Any) {
        UIView.animate(withDuration: 0.12) {
            self.contentView.backgroundColor = UIColor.darkGray
            UIView.animate(withDuration: 0.12) {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
        if (delegate != nil) {
            delegate?.clickSettingRow(setting: self)
        }
    }
    
}

protocol SettingRowDelegate {
    func clickSettingRow(setting: SettingRow)
}
