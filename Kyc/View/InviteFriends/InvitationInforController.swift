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
    @IBOutlet weak var exam1: UILabel!
    @IBOutlet weak var exam2: UILabel!
    @IBOutlet weak var exam3: UILabel!
    @IBOutlet weak var exam4: UILabel!
    @IBOutlet weak var exam5: UILabel!
    @IBOutlet weak var exam6: UILabel!
    @IBOutlet weak var exam7: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPromotionInformation()
    }
    //MARK: - Custom views
    override func customViews() {
        
    }
    
    func setupDefaultLayout() {
        promotionTitle.text = "EARN LIFETIME COMMISSIONS"
        subTitle.text = "for every friend referred!"
        bannerImage.image = #imageLiteral(resourceName: "share_friends")
        caption.text = "Earn 3% of whatever your referred friends purchase! As a bonus, you will also earn 1% of your friend's referees purchases."
        shortDes.text = "First 3 top referrals get the new Apple iPhone XR. Promotion ends 31st Dec 2018"
        longDes.text = "Our unique two tier referral system will allow you to earn passive income for life. Earn 3% from direct referee and 1% from child referees."
        exampleDes.text = ""
        exam1.text = "You"
        exam2.text = "/        \\"
        exam3.text = "A            B"
        exam4.text = "/                 \\"
        exam5.text = "C                   D"
        exam6.text = "If A buys $100 worth of tokens, you will earn $3"
        exam7.text = "If C buys $100 worth of tokens, A will earn $3 while You will earn $1"
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
