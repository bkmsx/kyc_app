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
    @IBOutlet weak var photo: UIImageView!
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
        if (clickable && delegate != nil) {
            UIView.animate(withDuration: 0.1) {
                self.contentView.backgroundColor = UIColor.lightGray
                UIView.animate(withDuration: 0.1, animations: {
                    self.contentView.backgroundColor = UIColor.clear
                })
            }
            delegate?.clickRoundView()
        }
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func loadImage(link: String) {
        photo.downloadedFrom(link: link)
    }
    
    func setPhoto(image: UIImage) {
        photo.image = image
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RoundView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = self.frame.size.height / 2
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(argb: Colors.easyBlue).cgColor
        innerView.backgroundColor = UIColor.init(argb: Colors.lightBlue)
        innerView.layer.cornerRadius = self.frame.size.height / 2 - 5
        photo.contentMode = UIViewContentMode.scaleAspectFit
        photo.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
    }
}

protocol RoundViewDelegate {
    func clickRoundView()
}
