//
//  HistoryTableViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableViewController: ParticipateCommonController, UITableViewDataSource, HistoryParticipateCellDelegate, NoParticipateViewDelegate{
    var histories: [ParticipateHistoryModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryList()
    }
    
    //MARK: - Get History List
    func getHistoryList() {
        
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.participateHistory, method: .get, parameters: nil, headers: headers) { (json) in
            let historiesDic = json["history"] as! [[String:Any]]
            self.histories = []
            for historyDic in historiesDic {
                let history = ParticipateHistoryModel(dic: historyDic)
                self.histories.append(history)
            }
            if (self.histories.count == 0) {
               self.addNoParticipateView()
            } else {
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - Custom views
    override func customViews() {
        setupTableView()
    }
    
    func addNoParticipateView() {
        DispatchQueue.main.async {
            let noParticipateView = NoParticipateView.init(frame: self.view.bounds)
            noParticipateView.layer.zPosition = 500
            noParticipateView.delegate = self
            self.view.addSubview(noParticipateView)
        }
    }
    
    func addNewItems() {
        goBackRootView()
    }
    
    //MARK: - TableView Datasource
    func setupTableView() {
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryParticipateCell", for: indexPath) as! HistoryParticipateCell
        cell.delegate = self
        let history = histories[indexPath.row]
        cell.logoImage.downloadedFrom(link: history.logo!)
        cell.projectTitle.text = history.title!.uppercased()
        cell.tokenPurchased.text = "\(history.tokensPurchased!) tokens purchased"
        cell.discountLabel.text = "\(history.discount!)% Discount"
        cell.participateDate.text = history.addedDate!
        cell.ethPaid.text = "\(history.amount!) \(history.paymentMode!) paid"
        cell.historyId = history.historyId!
        cell.paymentMethod = history.paymentMode
        return cell
    }
    
    //MARK: TableView Delegate
    func participateAgain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ProjectDetailViewController) as! ProjectDetailViewController
        vc.projectId = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteParticipateHistory(historyId: Int) {
        let params = [
            "history_id" : String(historyId)
        ]
        
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.participateDelete, method: .post, parameters: params, headers: headers) { (json) in
            self.getHistoryList()
        }
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    
    func gotoHistoryDetail(historyId: Int, paymentMethod: String) {
        if (paymentMethod != "USD") {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ETHParticipateDetailViewController) as! ETHParticipateDetailViewController
            vc.historyId = historyId
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.USDParticipateHistoryController) as! USDParticipateHistoryController
            vc.historyId = historyId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
