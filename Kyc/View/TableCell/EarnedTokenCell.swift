//
//  EarnedTokenCell.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/9/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class EarnedTokenCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tokenNumber: UILabel!
    @IBOutlet weak var tokenName: UILabel!
    
    var bonusToken: BonusToken? {
        didSet{
            userName.text = bonusToken?.userName!
            tokenNumber.text = String.init(format: "+%d", (bonusToken?.amount!)!)
            tokenName.text = bonusToken?.token!
        }
    }
}
