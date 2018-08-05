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
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Custom views
    override func customViews() {
        roundView.setImage(image: #imageLiteral(resourceName: "account"))
        verifyView.layer.cornerRadius = verifyView.frame.size.height / 2
        personalSetting.settingLabel.text = "Change Password"
        personalSetting.iconImage.image = #imageLiteral(resourceName: "blue_account")
        personalSetting.delegate = self
        
        updatePassport.settingLabel.text = "Update Passport"
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
        
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height / 2
        
        let firstName = UserDefaults.standard.string(forKey: UserProfiles.firstName)!
        let lastName = UserDefaults.standard.string(forKey: UserProfiles.lastName)!
        userName.text = "\(firstName.uppercased()) \(lastName.uppercased())"
        userEmail.text = UserDefaults.standard.string(forKey: UserProfiles.email)!
        let userAvatar = UserDefaults.standard.string(forKey: UserProfiles.selfiePhoto)!
        roundView.loadImage(link: userAvatar)
    }
    
    //MARK: - Logout
    @IBAction func logout(_ sender: Any) {
        UserModel.removeFromLocal()
        let nav = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginNavigationController)
        navigationController?.present(nav!, animated: true, completion: nil)
    }
    
    //MARK: - Setup Navigation Bar
    @IBAction func backToProjectList(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Share with friends
    @IBAction func shareWithFriends(_ sender: Any) {
        gotoInvitation()
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
        }
    }
    
    //MARK: - Goto Personal Information
    func gotoPersonalInformation() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UpdatePersonalInformationViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Goto Update Passport
    func gotoUpdatePassport() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UpdatePassportViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Goto Wallet Address
    func gotoWalletAddress() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.WalletListController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Goto Participate History
    func gotoParticipateHistory() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HistoryTableViewController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Goto Invitation
    func gotoInvitation() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.InvitationInforController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Goto Setting
    func gotoSettings() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ConfigurationViewController) as! ConfigurationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
