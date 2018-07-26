
//
//  ListProjectViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ListProjectViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setupNavigationBar()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as UITableViewCell
 
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true;
    }
    
    //MARK: - setup navigation bar
    func setupNavigationBar() {
       
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]
        let barView = LeftBarView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 15))
        let button = UIBarButtonItem.init(customView: barView)
        navigationItem.leftBarButtonItem = button
    }
    
    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
