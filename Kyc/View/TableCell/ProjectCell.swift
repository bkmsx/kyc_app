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
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var addedDate: UILabel!
    @IBOutlet weak var shortDescription: UITextView!
    @IBOutlet weak var badge: UIImageView!
    @IBOutlet weak var saleEnded: UILabel!
    
    var projectId: Int?
    var delegate: ProjectCellDelegate?
    
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

    @IBAction func clickDetail(_ sender: Any) {
        if (projectId != nil && delegate != nil) {
            delegate?.showDetail(projectId: projectId!)
        }
    }
}

protocol ProjectCellDelegate {
    func showDetail(projectId: Int)
}
