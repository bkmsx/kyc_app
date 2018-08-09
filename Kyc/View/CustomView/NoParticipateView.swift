//
//  NoParticipateView.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/9/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class NoParticipateView: UIView {
    var delegate: NoParticipateViewDelegate?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("NoParticipateView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        
    }
    
    @IBAction func clickButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.addNewItems()
        }
    }
    
    func setImage(_ image: UIImage) {
        roundView.setImage(image: image)
    }
    
    func setTitle(_ text: String) {
        title.text = text
    }
    
    func setMessage(_ text: String) {
        message.text = text
    }
    
    func setButtonTitle(_ text: String) {
        button.setTitle(text, for: .normal)
    }
}

protocol NoParticipateViewDelegate {
    func addNewItems()
}
