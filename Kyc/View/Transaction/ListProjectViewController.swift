
//
//  ListProjectViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class ListProjectViewController: ParticipateCommonController, UITableViewDataSource, ProjectCellDelegate {
    var projects: [ProjectModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("false", forKey: Constants.firstOpen)
        tableView.dataSource = self
        getProjectList()
    }

    //MARK: - Call API
    func getProjectList() {
        let headers = [
            "token": UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.projectList, method: .get, parameters: nil, headers: headers) { (json) in
            let projectsDic = json["projects"] as! [[String:Any]]
            for projectDic in projectsDic {
                let project = ProjectModel.init(json: projectDic)
                self.projects.append(project)
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        let project = projects[indexPath.row]
        cell.logoImage.downloadedFrom(link: project.logo!)
        cell.title.text = project.title?.uppercased()
        cell.addedDate.text = "ADDED: \(project.addedDate!)"
        cell.shortDescription.text = project.shortDescription!
        if let currentDiscount = project.currentDiscount {
            cell.discountPercent.text = "\(String(describing: currentDiscount))%"
        }
        if (project.status == "on_sale") {
            cell.saleEnded.isHidden = true
        }
        cell.projectId = project.projectId
        cell.badge.isHidden = !project.userParticipated!
        cell.delegate = self
        return cell
    }
    
    func showDetail(projectId: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ProjectDetailViewController) as! ProjectDetailViewController
        vc.projectId = projectId
        //FIXME: Segue to Transaction detail
//        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.USDDetailViewController) as! UIViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
