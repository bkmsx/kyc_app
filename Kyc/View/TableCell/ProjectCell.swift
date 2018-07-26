//
//  ProjectCell.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet weak var discountPercent: UILabel!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var companyLogo: UIView!
    @IBOutlet weak var detailButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
    //MARK: - setup Cell
    func setupCell() {
        detailButton.layer.cornerRadius = detailButton.frame.size.height / 2
        companyLogo.layer.cornerRadius = 10
        rootView.layer.cornerRadius = 10
        rootView.clipsToBounds = true
        discountPercent.layer.cornerRadius = discountPercent.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
