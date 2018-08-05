//
//  AddWalletController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/5/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import QRCodeReader

class AddWalletController: ParticipateCommonController, UploadButtonDelegate, QRCodeReaderViewControllerDelegate {

    var payments: [AppPaymentMethod] = []
    
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var walletAddress: UITextField!
    @IBOutlet weak var scanButton: UploadButton!
    @IBOutlet weak var dropDownButton: DropDownButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentMethods()
    }
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "ADD")
        roundView.setImage(image: #imageLiteral(resourceName: "account"))
        walletAddress.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        scanButton.setButtonIcon(image: #imageLiteral(resourceName: "blue_scan"))
        scanButton.setButtonTitle(title: "SCAN")
        scanButton.delegate = self
        dropDownButton.setTextMarginLeft(value: 10)
    }
    
    func getPaymentMethodId() -> Int {
        for payment in payments {
            if payment.name == dropDownButton.text {
                return payment.id!
            }
        }
        return 0
    }
    
    //MARK: - Scan QR
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.showSwitchCameraButton = false
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func startScan() {
        guard checkScanPermissions() else { return }
        readerVC.modalPresentationStyle = .currentContext
        readerVC.delegate               = self
        present(readerVC, animated: true, completion: nil)
    }
    //MARK: QRCodeReader Delegates
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true){
            self.walletAddress.text = result.value
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Call API
    func getPaymentMethods() {
        httpRequest(URLConstant.baseURL + URLConstant.paymentMethods) { json in
            var paymentString: [String] = []
            let dicPayments = json["paymentMethods"] as! [[String:Any]]
            for dicPayment in dicPayments {
                let payment = AppPaymentMethod.init(dic: dicPayment)
                self.payments.append(payment)
                paymentString.append(payment.name!)
                self.dropDownButton.setDataSource(source: paymentString)
            }
        }
    }
    
    func addNewWallet() {
        guard !(walletAddress.text?.isEmpty)! else {
            return
        }
        let params = [
            "method_id" : getPaymentMethodId(),
            "wallet_address" : walletAddress.text!
        ] as [String:Any]
        
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.addWallet, method: .post
        , parameters: params, headers: headers) { _ in
            self.goBack()
        }
    }

    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        addNewWallet()
    }
    
    func clickUploadButton(sender: Any) {
        startScan()
    }
}
