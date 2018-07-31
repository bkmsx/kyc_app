//
//  UpdateWalletAddressViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import QRCodeReader
import Alamofire

class UpdateWalletAddressViewController: ParticipateCommonController, QRCodeReaderViewControllerDelegate, UploadButtonDelegate {
    //MARK: - Properties
    
    //MARK: - Outlet
    @IBOutlet weak var currentWalletTextField: UITextField!
    @IBOutlet weak var newWalletTextField: UITextField!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var scanButton: UploadButton!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK: - Custom views
    override func customViews() {
        currentWalletTextField.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        newWalletTextField.setBottomBorder(color: UIColor.init(argb: Colors.darkGray))
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "UPDATE")
        scanButton.setButtonIcon(image: #imageLiteral(resourceName: "blue_scan"))
        scanButton.setButtonTitle(title: "SCAN")
        scanButton.delegate = self
        currentWalletTextField.text = UserDefaults.standard.string(forKey: UserProfiles.erc20Address)!
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        updateWallet()
    }
    //MARK: - Scan wallet
    func clickUploadButton(sender: Any) {
        startScan()
    }
    
    //MARK: QRCode
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
            self.newWalletTextField.text = result.value
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Update Wallet
    func updateWallet() {
        //FIXME: Remove comments

        if (newWalletTextField.text == "") {
            showMessage(message: "Please input new wallet")
            return
        }
        if (currentWalletTextField.text == newWalletTextField.text) {
            showMessage(message: "New wallet must be different to the current wallet")
            return
        }
        
        let params = [
            "erc20_address":newWalletTextField.text!
            ] as [String : Any]
        let headers = [
            "token": UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        
        Alamofire.request(URLConstant.baseURL + URLConstant.updateWallet, method:.post, parameters: params, encoding:JSONEncoding.default, headers: headers).responseJSON { response in
            let JSON = response.result.value as! NSDictionary
            let resultCode = JSON["code"] as! Int
            if (resultCode == 200) {
                self.goBack()
            } else {
                let message = JSON["message"] as! String
                self.showMessage(message: message)
            }
        }
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
