//
//  CopyTextField.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/27/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CopyLabel: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CopyTextField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
        contentView.layer.borderColor = UIColor.init(argb: Colors.lightBlue).cgColor
        contentView.layer.borderWidth = 1
    }

    @IBAction func copyText(_ sender: Any) {
        UIPasteboard.general.string =
    }
}
