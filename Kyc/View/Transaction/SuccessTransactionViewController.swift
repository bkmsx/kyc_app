//
//  SuccessTransactionViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SuccessTransactionViewController: ParticipateCommonController {
    var project: ProjectModel?
    let walletAddress = "0xFAF31560d94E7dDE9098dC99B3419b927b87bC4F"
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var tokenNumberLabel: ColorLabel!
    @IBOutlet weak var shareLabel: ColorLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageView.image = generateQRCode(from: walletAddress)
    }
    
    //MARK: - Custom views
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var copyLabel: CopyLabel!
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
        header.setSelectIndicator(index: 3)
        header.setCompanyLogo(link: (project?.logo)!)
        header.setProjectTitle(title: (project?.title?.uppercased())!)
        copyLabel.setText(text: walletAddress)
        
        tokenNumberLabel.setTextColor(shortText: "W Green Pay tokens", color: UIColor.white)
        tokenNumberLabel.setTextColor(shortText: "10 ETHER", color: UIColor.white)
        shareLabel.setTextColor(shortText: "GET 10 FREE TOKENS", color: UIColor.white)
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }
    
    //MARK: - Go to next
    func gotoNext() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.InvitationInforController)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func backToProjectList(_ sender: Any) {
        goBackRootView()
    }
    
    
    //MARK: - QR code generator
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
