//
//  ChooseShareMethodViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/3/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ChooseShareMethodViewController: ParticipateCommonController {
    @IBOutlet weak var copyLabel: CopyLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func gotoWhatsapp(_ sender: Any) {
        let originalString = "Hey please install KYC app to receive free tokens"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
        let url  = URL(string: "whatsapp://send?text=\(escapedString!)")
        
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func gotoSMS(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.PhoneListViewController) as! PhoneListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoTheSite(_ sender: Any) {
        if let url = URL(string: "http://novum.capital/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
