//
//  HistoryTableViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableViewController: ParticipateCommonController, UITableViewDataSource, HistoryParticipateCellDelegate{
    var histories: [ParticipateHistoryModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryList()
    }
    
    //MARK: - Get History List
    func getHistoryList() {
        histories = []
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        activityIndicator.startAnimating()
        Alamofire.request(URLConstant.baseURL + URLConstant.participateHistory, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            self.activityIndicator.stopAnimating()
            let json = response.result.value as! [String:Any]
            let code = json["code"] as! Int
            if (code == 200) {
                let historiesDic = json["history"] as! [[String:Any]]
                for historyDic in historiesDic {
                    let history = ParticipateHistoryModel(dic: historyDic)
                    self.histories.append(history)
                    self.tableView.reloadData()
                }
            }
        }
    }

    //MARK: - Custom views
    override func customViews() {
        setupTableView()
    }
    @IBAction func clickBack(_ sender: Any) {
        goBack()
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
        cell.historyId = history.historyId!
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
        
        Alamofire.request(URLConstant.baseURL + URLConstant.participateDelete, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let json = response.result.value as! [String:Any]
            let code = json["code"] as! Int
            if (code == 200) {
                self.getHistoryList()
            } else {
                self.showMessage(message: json["message"] as! String)
            }
        }
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
