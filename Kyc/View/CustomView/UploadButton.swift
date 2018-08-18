//
//  UploadButton.swift
//  TestCustomView
//
//  Created by Lai Trung Tien on 7/25/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class UploadButton: UIView {
    var delegate: UploadButtonDelegate?
    var lock = false
    var timer: Timer!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonTitle: UILabel!
    @IBOutlet weak var buttonIcon: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func clickUploadButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.09) {
            self.contentView.backgroundColor = UIColor.darkGray
            UIView.animate(withDuration: 0.09) {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
        guard let delegate = delegate, !lock else {
            return
        }
        delegate.clickUploadButton(sender: sender)
        lock = true
        timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false, block: { _ in
            self.lock = false
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UploadButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.layer.cornerRadius = frame.size.height / 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
        contentView.clipsToBounds = true
    }
    
    func setButtonIcon(image: UIImage) {
        buttonIcon.image = image
    }
    
    func setButtonTitle(title: String) {
        buttonTitle.text = title
    }
}

protocol UploadButtonDelegate {
    func clickUploadButton(sender: Any)
}
