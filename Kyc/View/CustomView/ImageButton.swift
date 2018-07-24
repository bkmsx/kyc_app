//
//  ImageButton.swift
//  TestCustomView
//
//  Created by Lai Trung Tien on 7/24/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ImageButton: UIView {
    var delegate: ImageButtonDelegate?
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
        Bundle.main.loadNibNamed("ImageButton", owner: self, options: nil)
        addSubview(contentView)
    }

    @IBAction func clickButton(_ sender: Any) {
        delegate!.imageButtonClick(sender)
    }
}

protocol ImageButtonDelegate: class {
    func imageButtonClick(_ sender: Any)
}
