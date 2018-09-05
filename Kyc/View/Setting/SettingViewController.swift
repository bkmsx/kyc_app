//
//  SettingViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SettingViewController: ParticipateCommonController, SettingRowDelegate {
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var personalSetting: SettingRow!
    @IBOutlet weak var updatePassport: SettingRow!
    @IBOutlet weak var updateWallet: SettingRow!
    @IBOutlet weak var participateHistory: SettingRow!
    @IBOutlet weak var setting: SettingRow!
    @IBOutlet weak var referralCode: SettingRow!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let countryCode = UserDefaults.standard.string(forKey: UserProfiles.countryCode)!
        let phoneNumber = UserDefaults.standard.string(forKey: UserProfiles.phoneNumber)!
        phoneLabel.text = "+\(countryCode) \(phoneNumber)"
    }
    
    //MARK: - Custom views
    override func customViews() {
        let firstName = UserDefaults.standard.string(forKey: UserProfiles.firstName)!
        let lastName = UserDefaults.standard.string(forKey: UserProfiles.lastName)!
        userName.text = "\(firstName.uppercased()) \(lastName.uppercased())"
        userEmail.text = UserDefaults.standard.string(forKey: UserProfiles.email)!
        let status = UserDefaults.standard.string(forKey: UserProfiles.status)!
        if (status != "CLEARED") {
            statusLabel.text = "Unverified"
            statusIcon.image = #imageLiteral(resourceName: "timer-sand")
        }
        
        roundView.setImage(image: #imageLiteral(resourceName: "account"))
        verifyView.layer.cornerRadius = verifyView.frame.size.height / 2
        personalSetting.settingLabel.text = "Change Password"
        personalSetting.iconImage.image = #imageLiteral(resourceName: "blue_account")
        personalSetting.delegate = self
        
        if (status != "CLEARED") {
            updatePassport.settingLabel.text = "Update Password (VERIFY NOW)"
        } else {
            updatePassport.settingLabel.text = "Update Passport"
        }
        updatePassport.iconImage.image = #imageLiteral(resourceName: "blue_passport")
        updatePassport.delegate = self
        
        updateWallet.settingLabel.text = "Update Wallet"
        updateWallet.iconImage.image = #imageLiteral(resourceName: "blue_wallet")
        updateWallet.delegate = self
        
        participateHistory.settingLabel.text = "Participation History"
        participateHistory.iconImage.image = #imageLiteral(resourceName: "blue_history")
        participateHistory.delegate = self
        
        setting.settingLabel.text = "Settings"
        setting.iconImage.image = #imageLiteral(resourceName: "blue_setting")
        setting.delegate = self
        
        referralCode.settingLabel.text = "Referral Code"
        referralCode.iconImage.image = #imageLiteral(resourceName: "blue_setting")
        referralCode.delegate = self
        
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height / 2
    }
    
    //MARK: - Setting Row Delegate
    func clickSettingRow(setting: SettingRow) {
        if (setting == personalSetting) {
            gotoPersonalInformation()
        } else if (setting == updatePassport) {
            gotoUpdatePassport()
        } else if (setting == updateWallet) {
            gotoWalletAddress()
        } else if (setting == participateHistory) {
            gotoParticipateHistory()
        } else if (setting == self.setting) {
            gotoSettings()
        } else if (setting == self.referralCode) {
            gotoReferralCode()
        }
    }
    
    //MARK: - Navigations
    @IBAction func logout(_ sender: Any) {
        UserModel.removeFromLocal()
        let nav = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginNavigationController)
        navigationController?.present(nav!, animated: true, completion: nil)
    }
    
    @IBAction func backToProjectList(_ sender: Any) {
        goBack()
    }
    
    func gotoPersonalInformation() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UpdatePersonalInformationViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func gotoUpdatePassport() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UpdatePassportViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func gotoWalletAddress() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.WalletListController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func gotoParticipateHistory() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HistoryTableViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func gotoSettings() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ConfigurationViewController) as! ConfigurationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoReferralCode() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ReferralCodeController) as! ReferralCodeController
        navigationController?.pushViewController(vc, animated: true)
    }
}
