//
//  BonusTier.swift
//  Kyc
//
//  Created by Lai Trung Tien on 9/17/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class BonusTier: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var bonus: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BonusTier", owner: self, options: nil)
        addSubview(contentView)
    }
    
}
