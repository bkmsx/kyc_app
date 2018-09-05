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
    //From previous
    var projectId: Int?
    var participateAgain: Bool?
    //Inside
    var project: ProjectModel?
    var status: String!
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
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectDetail()
    }
    //MARK: - Custom views
    override func customViews() {
        companyLogo.layer.cornerRadius = 10
        participateButton.layer.cornerRadius = participateButton.frame.size.height / 2
        inviteButton.layer.cornerRadius = inviteButton.frame.size.height / 2
        status = UserDefaults.standard.string(forKey: UserProfiles.status)!
        if (status != "CLEARED") {
            statusIcon.image = #imageLiteral(resourceName: "timer-sand")
            statusLabel.text = "You are unverified"
        }
    }
    
    //MARK: - Get Project Detail
    func getProjectDetail() {
        guard let projectId = projectId else {return}
        let headers = [
            "token": UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        let params = [
            "project_id": String(projectId)
        ]
        httpRequest(URLConstant.baseURL + URLConstant.projectDetail, method: .get, parameters: params, headers: headers) { (json) in
            let projectDic = json["project"] as! [String:Any]
            self.project = ProjectModel(json: projectDic)
            self.populateViews(project: self.project!)
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
    
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func goNext(_ sender: Any) {
        guard status == "CLEARED" else {
            showMessages("Your account is unverified. Please go to Update Passport to verify your account")
            return
        }
        if (participateAgain == nil) {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.AgreeTermConditionViewController) as! AgreeTermConditionViewController
            vc.project = project
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.WalletInputController) as! WalletInputController
            vc.project = project
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
        guard project?.isPromoted == 1 else {
            showMessages("This project is not promoted")
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.InvitationInforController) as! InvitationInforController
        vc.projectId = projectId
        vc.projectName = project?.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
