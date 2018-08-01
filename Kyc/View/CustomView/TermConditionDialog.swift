//
//  TermConditionDialog.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/1/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TermConditionDialog: UIView, Modal, TermConditionViewDelegate {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.frame = frame
        addSubview(backgroundView)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(diTapOutSide)))
        
        dialogView = TermConditionView(frame: CGRect(x: 20, y: frame.height, width: frame.width - 40, height: frame.height - 50))
        (dialogView as! TermConditionView).delegate = self
        addSubview(dialogView)
    }
    
    func closeDialog() {
        dismiss(animated: true)
    }
    
    @objc func diTapOutSide() {
        dismiss(animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
