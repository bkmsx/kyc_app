//
//  HistoryTableViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class HistoryTableViewController: ParticipateCommonController, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Custom views
    override func customViews() {
        setupTableView()
    }
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - Setup TableView
    func setupTableView() {
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryParticipateCell", for: indexPath) as UITableViewCell
        return cell
        
    }
}
