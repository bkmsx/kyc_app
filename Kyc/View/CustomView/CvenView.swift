//
//  CvenView.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/30/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CvenView: UIView {
    
    var delegate: CvenViewDelegate?

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
        Bundle.main.loadNibNamed("CvenView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    @IBAction func closeDialog(_ sender: Any) {
        if let delegate = delegate {
            delegate.closeDialog()
        }
    }
}

protocol CvenViewDelegate {
    func closeDialog()
}
