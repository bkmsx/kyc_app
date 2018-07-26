//
//  SuccessTransactionViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class SuccessTransactionViewController: ParticipateCommonController {

    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var qrImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageView.image = generateQRCode(from: "0xasdfadfasfasf")
    }
    
    //MARK: - Custom views
    @IBOutlet weak var header: ParticipateHeader!
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SHARE WITH FRIENDS")
        header.setSelectIndicator(index: 3)
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }
    
    //MARK: - Go to next
    func gotoNext() {
        navigationController?.popToRootViewController(animated: true)
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
