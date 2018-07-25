//
//  RoundView.swift
//  TestCustomView
//
//  Created by Lai Trung Tien on 7/23/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class RoundView: UIView {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var delegate: RoundViewDelegate?
    var clickable = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func clickButton(_ sender: Any) {
        if clickable {
            delegate?.clickRoundView()
        }
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RoundView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(argb: Colors.easyBlue).cgColor
        innerView.backgroundColor = UIColor.init(argb: Colors.lightBlue)
        innerView.layer.cornerRadius = self.frame.size.height / 2 - 5
    }
}

protocol RoundViewDelegate {
    func clickRoundView()
}
