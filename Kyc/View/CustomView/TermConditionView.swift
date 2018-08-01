//
//  TermConditionView.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/1/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TermConditionView: UIView{
    var delegate: TermConditionViewDelegate?
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TermConditionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    @IBAction func close(_ sender: Any) {
        if let delegate = delegate {
            delegate.closeDialog()
        }
    }
}

protocol TermConditionViewDelegate {
    func closeDialog()
}
