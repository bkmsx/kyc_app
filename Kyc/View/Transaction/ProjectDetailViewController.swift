//
//  ProjectDetailViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {

    @IBOutlet weak var companyLogo: UIView!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        customViews()
    }
    
    //MARK: - Custom views
    func customViews() {
        companyLogo.layer.cornerRadius = 10
        participateButton.layer.cornerRadius = participateButton.frame.size.height / 2
        inviteButton.layer.cornerRadius = inviteButton.frame.size.height / 2
    }
    
    //MARK: - setup navigation bar
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]
        
    }
    
    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
