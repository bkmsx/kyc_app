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
    
    @IBOutlet weak var referralCodeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Custom views
    override func customViews() {
        codeTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        applyButton.layer.cornerRadius = applyButton.frame.size.height / 2
        totalPoint.layer.cornerRadius = totalPoint.frame.size.height / 2
        totalPoint.clipsToBounds = true
        tableView.dataSource = self
    }
    @IBAction func applyReferralCode(_ sender: Any) {
        submitReferralCode()
    }
    
    //MARK: - TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarnedTokenCell", for: indexPath) as! EarnedTokenCell
        return cell
    }
    
    //MARK: - Call API
    func submitReferralCode() {
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        let params = [
            "referral_code" : codeTextField.text!
        ] as [String:Any]
        httpRequest(URLConstant.baseURL + URLConstant.updateReferralCode, method: .post, parameters: params, headers: headers) { _ in
            self.makeToast("Update referral code successfully")
            self.referralCodeView.isHidden = true
        }
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
}
