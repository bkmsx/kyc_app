//
//  WalletCell.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {
    var delegate: WalletCellDelegate?
    var walletAddress: WalletAddress? {
        didSet {
            self.addressLabel.text = self.walletAddress?.address!
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
       
    }
    
    @IBAction func editWallet(_ sender: Any) {
        if let delegate = delegate, let walletAddress = walletAddress {
            delegate.editWallet(wallet: walletAddress)
        }
    }
    
    @IBAction func deleteWallet(_ sender: Any) {
        if let delegate = delegate, let walletAddress = walletAddress {
            delegate.deleteWallet(wallet: walletAddress)
        }
    }
}

protocol WalletCellDelegate {
    func editWallet(wallet: WalletAddress)
    func deleteWallet(wallet: WalletAddress)
}
