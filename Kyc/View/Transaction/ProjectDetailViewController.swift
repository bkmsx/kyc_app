//
//  ProjectDetailViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class ProjectDetailViewController: ParticipateCommonController {
    var projectId: Int?
    var project: ProjectModel?
    @IBOutlet weak var companyLogo: UIView!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var addedDate: UILabel!
    @IBOutlet weak var shortDescription: UITextView!
    @IBOutlet weak var detailedDescription: UITextView!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var discountPercent: UILabel!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectDetail()
    }
    
    //MARK: - Get Project Detail
    func getProjectDetail() {
        guard let projectId = projectId else {return}
        activityIndicator.startAnimating()
        let token = UserDefaults.standard.string(forKey: UserProfiles.token)!
        let headers = ["token": token]
        let params = ["project_id": String(projectId)]
        
        Alamofire.request(URLConstant.baseURL + URLConstant.projectDetail, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            let json = response.result.value as! [String:Any]
            let projectDic = json["project"] as! [String:Any]
            self.project = ProjectModel(json: projectDic)
            self.populateViews(project: self.project!)
            self.activityIndicator.stopAnimating()
        }
    }
    
    //MARK: - Populate views
    func populateViews(project: ProjectModel) {
        logoImage.downloadedFrom(link: project.logo!)
        projectTitle.text = project.title?.uppercased()
        addedDate.text = "ADDED: \(project.addedDate!)"
        shortDescription.text = project.shortDescription
        detailedDescription.text = project.detailedDescription
        navigationTitle.title = project.title?.uppercased()
        if (project.currentSaleStart != nil && project.currentSaleEnd != nil) {
            period.text = "\(project.currentSaleStart!) - \(project.currentSaleEnd!)"
        } else {
            period.text = "Over"
        }
        if (project.currentDiscount != nil) {
            discountPercent.text = "\(project.currentDiscount!)%"
        } else {
            discountPercent.text = "None"
        }
    }
    
    //MARK: - Custom views
    override func customViews() {
        companyLogo.layer.cornerRadius = 10
        participateButton.layer.cornerRadius = participateButton.frame.size.height / 2
        inviteButton.layer.cornerRadius = inviteButton.frame.size.height / 2
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func goNext(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.AgreeTermConditionViewController) as! AgreeTermConditionViewController
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.WalletInputController) as! WalletInputController
        vc.project = project
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
