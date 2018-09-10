//
//  ChooseShareMethodViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/3/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ChooseShareMethodViewController: ParticipateCommonController {
    //From previous
    var projectName: String?
    
    @IBOutlet weak var copyLabel: CopyLabel!
    @IBOutlet weak var referralLinkButton: UIButton!
    
    //MARK: - Custom views
    override func customViews() {
        copyLabel.setText(text: UserDefaults.standard.string(forKey: UserProfiles.referralCode)!)
        copyLabel.setFontSize(22)
        referralLinkButton.setTitle("bit.ly/2NmpSHg", for: .normal)
    }
    
    //MARK: - Events
    @IBAction func gotoTheSite(_ sender: Any) {
        let link = "https://" + (sender as! UIButton).currentTitle!
        UIPasteboard.general.string = link
        makeToast("Copy: " + link)
        //        if let url = URL(string: "http://novum.capital/") {
        //            UIApplication.shared.open(url, options: [:])
        //        }
    }

    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func gotoWhatsapp(_ sender: Any) {
        let referralCode = UserDefaults.standard.string(forKey: UserProfiles.referralCode)!
        var originalString = " "
        
        if let projectName = projectName {
            originalString = "Hey, participate in project: \"\(projectName)\" with referral code:\"\(referralCode)\" to get free token!"
        } else {
            originalString = "Hey, install KYC app and register with this referral code: \"\(referralCode)\" to get free token! Site: https://www.concordia.ventures"
        }
        
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
        let url  = URL(string: "whatsapp://send?text=\(escapedString!)")
        
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func gotoSMS(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.PhoneListViewController) as! PhoneListViewController
        vc.projectName = projectName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
