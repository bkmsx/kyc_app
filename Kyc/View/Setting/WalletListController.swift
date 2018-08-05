//
//  WalletListController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class WalletListController: ParticipateCommonController, UITableViewDataSource, UITableViewDelegate, WalletCellDelegate {
    var walletCategories: [WalletCategory] = []
    var selectedAddress: WalletAddress?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWalletList()
    }
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "ADD NEW WALLET")
        roundView.setImage(image: #imageLiteral(resourceName: "account"))
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = walletCategories[section]
        return category.wallets.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return walletCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        cell.delegate = self
        let walletAddress = walletCategories[indexPath.section].wallets[indexPath.row]
        cell.walletAddress = walletAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return walletCategories[section].methodName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.init(argb: Colors.lightBlue)
    }
    
    //MARK: - Cell Delegate
    func editWallet(wallet: WalletAddress) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UpdateWalletAddressViewController) as! UpdateWalletAddressViewController
        vc.walletAddress = wallet
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteWallet(wallet: WalletAddress) {
        self.selectedAddress = wallet
        showConfirmDialog()
    }
    
    //MARK: - Call API
    func getWalletList() {
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.userWallets, headers: headers) { (json) in
            self.walletCategories = []
            let categories = json["wallets"] as! [[String:Any]]
            for category in categories {
                let walletCategory = WalletCategory.init(dic: category)
                self.walletCategories.append(walletCategory)
            }
            self.tableView.reloadData()
        }
    }
    
    func delete() {
        if let selectedAddress = selectedAddress {
            let params = [
                "wallet_id" : selectedAddress.walletId!
            ] as [String:Any]
            let headers = [
                "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
            ]
            httpRequest(URLConstant.baseURL + URLConstant.deleteWallet, method: .post, parameters: params, headers: headers) { _ in
                self.getWalletList()
            }
        }
    }

    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.AddWalletController) as! AddWalletController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Dialog
    func showConfirmDialog() {
        let dialog = UIAlertController.init(title: "Delete Wallet", message: "Are you sure want to delete this wallet", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { _ in
            self.delete()
        }
        let cancelAction = UIAlertAction.init(title: "CANCEL", style: .cancel, handler: nil)
        dialog.addAction(okAction)
        dialog.addAction(cancelAction)
        self.present(dialog, animated: true, completion: nil)
    }
}
