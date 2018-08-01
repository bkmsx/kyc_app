//
//  CustomAlertDialog.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class CustomAlertDialog: UIView, Modal, DialogViewDelegate{
    var backgroundView = UIView()
    var dialogView = DialogView()
    var delegate: CustomAlertDialogDelegate?
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        print(frame)
        addSubview(backgroundView)
        dialogView = DialogView.init(frame: CGRect.init(x: 32, y: frame.height, width: frame.width - 64, height: 300))
        dialogView.delegate = self
        addSubview(dialogView)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func chooseOption(yes: Bool) {
        if (yes) {
            if let delegate = delegate {
                delegate.agreeToDelete()
            }
        }
        dismiss(animated: true)
    }
    
}

protocol CustomAlertDialogDelegate {
    func agreeToDelete()
}
