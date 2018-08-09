//
//  ReferralCodeController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/9/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ReferralCodeController: ParticipateCommonController, UITableViewDataSource {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var totalPoint: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Custom views
    override func customViews() {
        codeTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        applyButton.layer.cornerRadius = applyButton.frame.size.height / 2
        totalPoint.layer.cornerRadius = totalPoint.frame.size.height / 2
        totalPoint.clipsToBounds = true
        tableView.dataSource = self
    }
    
    //MARK: - TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarnedTokenCell", for: indexPath) as! EarnedTokenCell
        return cell
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
}
