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
        Bundle.main.loadNibNamed("ImageButton", owner: self, options: nil)
        addSubview(contentView)
    }
    
    func setButtonTitle(title: String) {
        label.text = title
    }

    @IBAction func buttonClick(_ sender: Any) {
        if (delegate != nil) {
           delegate!.imageButtonClick(sender)
        }
    }
}

protocol ImageButtonDelegate: class {
    func imageButtonClick(_ sender: Any)
}
