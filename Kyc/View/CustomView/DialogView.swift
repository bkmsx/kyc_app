//
//  DialogView.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class DialogView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var delegate: DialogViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DialogView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.layer.cornerRadius = 10
        yesButton.layer.cornerRadius = yesButton.frame.size.height / 2
        cancelButton.layer.cornerRadius = cancelButton.frame.size.height / 2
        cancelButton.layer.borderColor = UIColor.gray.cgColor
        cancelButton.layer.borderWidth = 1
    }
    @IBAction func clickYes(_ sender: Any) {
        if (delegate != nil) {
            delegate?.chooseOption(yes: true)
        }
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        if (delegate != nil) {
            delegate?.chooseOption(yes: false)
        }
    }
}

protocol DialogViewDelegate {
    func chooseOption(yes: Bool)
}
