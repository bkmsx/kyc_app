//
//  SellViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/30/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SellViewController: UIViewController, IndicatorInfoProvider {
    let WALLET = "0x688dde13bD594A9030feeFe6fa39cb353B7351c7"
    
    
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var walletAddress: CopyLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletAddress.setText(text: WALLET)
        qrCode.image = generateQRCode(WALLET)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "SELL")
    }

    @IBAction func showCvenDialog(_ sender: Any) {
        CvenDialog().show(animated: true)
    }
    //MARK: - QR code generator
    func generateQRCode(_ string: String) -> UIImage? {
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
