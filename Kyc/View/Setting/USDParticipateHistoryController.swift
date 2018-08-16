//
//  USDParticipateHistoryController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/4/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class USDParticipateHistoryController: ParticipateCommonController {
    //From previous
    var historyId: Int?
    //Inside
    var history: ParticipateHistoryModel?
    
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var participateHeader: ParticipateHeader!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var tokenNumber: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var swiftCode: UILabel!
    @IBOutlet weak var bankAddress: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var bankDetailBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryDetail()
    }
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
        imageButton.delegate = self
        participateHeader.hideIndicator()
        bankDetailBackground.layer.cornerRadius = 10
        bankDetailBackground.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
    }
    
    //MARK: - Get Data
    func getHistoryDetail() {
        guard let historyId = historyId else {
            return
        }
        let params = [
            "history_id" : String(historyId)
        ]
        
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        
        httpRequest(URLConstant.baseURL + URLConstant.participateDetail, method: .get, parameters: params, headers: headers) { (json) in
            let historyDic = json["history_detail"] as! [String:Any]
            let history = ParticipateHistoryModel.init(dic: historyDic)
            self.participateHeader.setCompanyLogo(link: history.logo!)
            self.participateHeader.setProjectTitle(title: history.title!)
            self.tokenNumber.text = "Tokens purchased: \(history.tokensPurchased!)"
            self.paymentMethod.text = "Payment method: \(history.paymentMode!)"
            self.amountLabel.text = "Total amount: \(history.amount!)"
            self.price.text = "1 TOKEN = \(history.price!) \(history.paymentMode!)"
            let paymentMethod = history.paymentDestination
            self.bankName.text = paymentMethod?.bankName
            self.swiftCode.text = paymentMethod?.swiftCode
            self.bankAddress.text = paymentMethod?.bankAddress
            self.accountName.text = paymentMethod?.accountName
            self.accountNumber.text = paymentMethod?.accountNumber
            self.businessAddress.text = paymentMethod?.holderAddress
            self.history = history
        }
    }

    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        guard let history = history, history.isPromoted == 1 else {
            showMessages("This project is not promoted")
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.InvitationInforController) as! InvitationInforController
        vc.projectId = history.projectId
        vc.projectName = history.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
