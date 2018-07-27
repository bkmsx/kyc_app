//
//  HistoryParticipateCell.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class HistoryParticipateCell: UITableViewCell {
    @IBOutlet weak var companyLogo: UIView!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var statusLabel: ColorLabel!
    @IBOutlet weak var tokenPurchased: ColorLabel!
    @IBOutlet weak var ethPaid: ColorLabel!
    @IBOutlet weak var usdPaid: ColorLabel!
    @IBOutlet weak var discountLabel: ColorLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        companyLogo.layer.cornerRadius = 10
        participateButton.layer.cornerRadius = participateButton.frame.size.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
        
        
        statusLabel.setTextColor(shortText: "STATUS:", color: UIColor.init(argb: Colors.darkGray))
        tokenPurchased.setTextColor(shortText: "tokens purchased", color: UIColor.init(argb: Colors.darkGray))
        ethPaid.setTextColor(shortText: "ETH paid", color: UIColor.init(argb: Colors.darkGray))
        usdPaid.setTextColor(shortText: "USD paid", color: UIColor.init(argb: Colors.darkGray))
        discountLabel.setTextColor(shortText: "Discount", color: UIColor.init(argb: Colors.darkGray))
        statusLabel.layer.borderColor = UIColor.init(argb: Colors.lightBlue).cgColor
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = statusLabel.frame.size.height / 2
        statusLabel.clipsToBounds = true
    }

}
