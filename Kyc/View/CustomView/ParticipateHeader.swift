//
//  ParticipateHeader.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ParticipateHeader: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var companyLogo: UIView!
    @IBOutlet weak var indicatorContainer: UIView!
    var indicators: [UIView] = []
    static let INDICATOR_WIDTH = 12
    static let SPACE = 30
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ParticipateHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        companyLogo.layer.cornerRadius = 10
        for index in 0...3 {
            let indicator = UIView.init(frame: CGRect.init(x: index * (ParticipateHeader.INDICATOR_WIDTH + ParticipateHeader.SPACE), y: 0, width: ParticipateHeader.INDICATOR_WIDTH, height: ParticipateHeader.INDICATOR_WIDTH))
            indicators.append(indicator)
            indicator.layer.cornerRadius = CGFloat(ParticipateHeader.INDICATOR_WIDTH / 2)
            indicatorContainer.addSubview(indicator)
            indicator.backgroundColor = UIColor.white
        }
        setSelectIndicator(index: 0)
    }
    
    func setSelectIndicator(index: Int) {
        for i in 0...index {
            indicators[i].backgroundColor = UIColor.init(argb: Colors.lightBlue)
        }
    }
}
