//
//  SlideIndicator.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/25/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SlideIndicator: UIView {
    let INDICATOR_SIZE = 12
    let SPACE = 20
    let NUMBER_INDICATOR = 5
    
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
        Bundle.main.loadNibNamed("SlideIndicator", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
    func setIndicator(_ position: Int) {
        let width = NUMBER_INDICATOR * (INDICATOR_SIZE + SPACE) - SPACE
        let left = (UIScreen.main.bounds.width - CGFloat(width)) / 2
        for index in 0...NUMBER_INDICATOR-1 {
            let indicator = UIView.init(frame: CGRect.init(x: Int(left + CGFloat(index * (INDICATOR_SIZE + SPACE))), y: 0, width: INDICATOR_SIZE, height: INDICATOR_SIZE))
            contentView.addSubview(indicator)
            indicator.layer.cornerRadius = CGFloat(INDICATOR_SIZE / 2)
            if (index == position) {
                indicator.backgroundColor = UIColor.white
            } else {
                indicator.backgroundColor = UIColor.init(argb: Colors.lightBlue)
            }
            
        }
    }
}

