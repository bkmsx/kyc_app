//
//  CvenDialog.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/30/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CvenDialog: UIView, Modal, CvenViewDelegate {
    var backgroundView = UIView()
    
    var dialogView = UIView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.frame = bounds
        addSubview(backgroundView)
        dialogView = CvenView.init(frame: CGRect(x: 16, y: frame.height, width: frame.width - 32, height: 400))
        addSubview(dialogView)
        (dialogView as! CvenView).delegate = self
        backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(touchBackground)))
    }
    
    func closeDialog() {
        dismiss(animated: true)
    }
    
    @objc func touchBackground() {
        dismiss(animated: true)
    }
}
