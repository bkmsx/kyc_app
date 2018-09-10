//
//  InvitationInforController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/27/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class InvitationInforController: ParticipateCommonController {
    //From previous
    var projectId: Int?
    var projectName: String?
    
    @IBOutlet weak var promotionTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var exampleDes: UILabel!
    @IBOutlet weak var longDes: UILabel!
    @IBOutlet weak var shortDes: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPromotionInformation()
    }
    //MARK: - Custom views
    override func customViews() {
        
    }
    
    func setupDefaultLayout() {
        promotionTitle.text = "EARN FREE TOKENS"
        subTitle.text = "for every friend referred!"
        bannerImage.image = #imageLiteral(resourceName: "share_friends")
        caption.text = "We are giving away special prizes for referring a friend to download this App"
        shortDes.text = "Win 3 Nano Ledger S every month!"
        longDes.text = "One chance earned for every friend referred. Earn mega 10x chance multiplier if you refer 3 or more friends."
        exampleDes.text = "E.g. If you referred 1 friend, your chances earned is 1. However, if you referred 3 friends, your chances earned will be 30."
    }
    
    func setupLayout(_ promotion: PromotionInformation) {
        promotionTitle.text = promotion.title!
        subTitle.text = promotion.subTitle!
        if (promotion.useDefaultBanner == 0) {
            bannerImage.downloadedFrom(link: promotion.bannerImage!)
        }
        caption.text = promotion.caption!
        shortDes.text = promotion.shortDes!
        longDes.text = promotion.detailDes!
        exampleDes.text = promotion.exampleDes!
    }

    //MARK: - Call API
    func getPromotionInformation() {
        guard let projectId = projectId else {
            setupDefaultLayout()
            return
        }
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        let params = [
            "project_id" : projectId
        ] as [String:Any]
        
        httpRequest(URLConstant.baseURL + URLConstant.projectShare, method: .get, parameters: params, headers: headers) { (json) in
            let promotionDic = json["promotion"] as! [String:Any]
            let promotion = PromotionInformation.init(dic: promotionDic)
            self.setupLayout(promotion)
        }
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func gotoChooseShareMethod(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ChooseShareMethodViewController) as! ChooseShareMethodViewController
        vc.projectName = projectName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
