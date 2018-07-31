
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getProjectList()
    }

    //MARK: - Get Project List
    func getProjectList() {
        activityIndicator.startAnimating()
        let token = UserDefaults.standard.string(forKey: UserProfiles.token)!
        let header = ["token": token]
        print(header)
        Alamofire.request(URLConstant.baseURL + URLConstant.projectList, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            let json = response.result.value as! [String:Any]
            let projectsDic = json["projects"] as! [[String:Any]]
            for projectDic in projectsDic {
                let project = ProjectModel.init(json: projectDic)
                self.projects.append(project)
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
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
        cell.projectId = project.projectId
        cell.delegate = self
        return cell
    }
    
    func showDetail(projectId: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ProjectDetailViewController) as! ProjectDetailViewController
        vc.projectId = projectId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
