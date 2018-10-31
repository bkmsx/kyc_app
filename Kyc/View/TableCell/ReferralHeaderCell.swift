//
//  ReferralHeaderCell.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/31/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ReferralHeaderCell: UITableViewCell {
    @IBOutlet weak var directReferral: UILabel!
    @IBOutlet weak var secondeTier: UILabel!
    @IBOutlet weak var totalEarned: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        directReferral.text = "DIRECT REFERRAL"
        secondeTier.text = "2ND TIER"
        totalEarned.text = "TOTAL EARNED (CVEN)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
