//
//  ReferralCodeController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/9/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ReferralCodeController: ParticipateCommonController, UITableViewDataSource, UITableViewDelegate {

    //Inside
    var bonusList = [BonusToken]()
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var totalPoint: UILabel!
    @IBOutlet weak var referralCodeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topAlignTotalCven: NSLayoutConstraint!
    @IBOutlet weak var zeroFriends: UILabel!
    @IBOutlet weak var totalCvenTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBonusList()
    }
    
    //MARK: - Custom views
    override func customViews() {
        codeTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        applyButton.layer.cornerRadius = applyButton.frame.size.height / 2
        totalPoint.layer.cornerRadius = totalPoint.frame.size.height / 2
        totalPoint.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        let referredBy = UserDefaults.standard.integer(forKey: UserProfiles.referralBy)
        if (referredBy != 0) {
            referralCodeView.isHidden = true
            topAlignTotalCven.constant = 40
        }
        totalCvenTitle.text = "TOTAL CVEN EARNED"
    }
    @IBAction func applyReferralCode(_ sender: Any) {
        submitReferralCode()
    }
    
    //MARK: - TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarnedTokenCell", for: indexPath) as! EarnedTokenCell
        cell.bonusToken = bonusList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralHeaderCell") as! ReferralHeaderCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
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
    
    func getBonusList() {
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.bonusList, method: .get, parameters: nil, headers: headers) { (json) in
            let bonusListDic = json["referral_list"] as! [[String:Any]]
            var totalBonus = 0.0
            for bonusDic in bonusListDic {
                let bonus = BonusToken.init(dic: bonusDic)
                self.bonusList.append(bonus)
                totalBonus += bonus.amount!
            }
            if self.bonusList.isEmpty {
                self.zeroFriends.isHidden = false
            }
            self.tableView.reloadData()
            self.totalPoint.text = String.init(format: "%.3f", totalBonus)
        }
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
}
