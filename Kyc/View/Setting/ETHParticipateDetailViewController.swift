//
//  ETHParticipateDetailViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/4/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ETHParticipateDetailViewController: ParticipateCommonController {
    //From previous
    var historyId: Int?
    //Inside
    var history: ParticipateHistoryModel?
    @IBOutlet weak var participateHeader: ParticipateHeader!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var tokenNumber: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var copyLabel: CopyLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryDetail()
    }
    
    //MARK: - Custom views
    override func customViews() {
        participateHeader.hideIndicator()
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
        imageButton.delegate = self
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
            self.copyLabel.setText(text: (history.paymentDestination?.walletAddress!)!)
            self.qrCode.image = self.generateQRCode(from: (history.paymentDestination?.walletAddress!)!)
            self.price.text = "1 TOKEN = \(history.price!) \(history.paymentMode!)"
            self.history = history
        }
    }

    //MARK: - Navigation
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
