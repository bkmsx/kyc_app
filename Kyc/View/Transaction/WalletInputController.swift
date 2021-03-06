//
//  WalletInputController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import QRCodeReader

class WalletInputController: ParticipateCommonController, UploadButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DropDownButtonDelegate, QRCodeReaderViewControllerDelegate {
    //From previous
    var project: ProjectModel?
    //Inside
    var selectedPaymentMethod: PaymentMethodModel?
    var passportImage: UIImage?
    var walletDropDown = DropDown()
    var walletList: [WalletCategory] = []
    var currentWalletList: [String] = []
    
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var walletAddress: UITextField!
    @IBOutlet weak var uploadButton: UploadButton!
    @IBOutlet weak var dropdownButton: DropDownButton!
    @IBOutlet weak var walletAddressTitle: UILabel!
    @IBOutlet weak var walletNotice: UILabel!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyBoard()
        getWalletList()
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "NEXT")
        header.setSelectIndicator(index: 1)
        
        uploadButton.delegate = self
        uploadButton.setButtonIcon(image: UIImage(named: "blue_scan")!)
        uploadButton.setButtonTitle(title: "SCAN")
        
        roundView.setImage(image: #imageLiteral(resourceName: "check"))
        walletView.layer.cornerRadius = walletView.frame.size.height / 2
        walletView.clipsToBounds = true
        
        if let project = project {
            header.setCompanyLogo(link: (project.logo)!)
            header.setProjectTitle(title: (project.title?.uppercased())!)
            var paymentMethods: [String] = []
            for method in project.paymentMethods {
                paymentMethods.append(method.methodName!)
            }
            dropdownButton.setDataSource(source: paymentMethods)
            dropdownButton.setTextMarginLeft(value: 10)
            dropdownButton.delegate = self
            didSelectDropDown(index: 0, text: paymentMethods[0])
            setupWalletDropDown()
        }
    }
    
    func clickUploadButton(sender: Any) {
        startScan()
//        getPassport()
    }
    
    //MARK: - Scan QR
    func startScan() {
        guard checkScanPermissions() else { return }
        readerVC.modalPresentationStyle = .currentContext
        readerVC.delegate               = self
        present(readerVC, animated: true, completion: nil)
    }
    
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
    
    //MARK: - Dropdown
    func setupWalletDropDown() {
        walletDropDown.anchorView = walletView
        walletDropDown.bottomOffset = CGPoint.init(x: 0, y: walletView.frame.size.height)
        walletDropDown.selectionAction = { [weak self] (index, item) in
            self?.walletAddress.text = item
        }
    }
    
    @IBAction func showWalletDropDown(_ sender: Any) {
        walletDropDown.show()
    }
    
    func setDropDownDataSource() {
        for walletCategory in walletList {
            if (walletCategory.methodName == dropdownButton.text) {
                for wallet in walletCategory.wallets {
                    self.currentWalletList.append(wallet.address!)
                }
                break
            }
        }
        walletDropDown.dataSource = self.currentWalletList
    }
    
    func didSelectDropDown(index: Int,text: String) {
        for paymentMethod in (project?.paymentMethods)! {
            if (paymentMethod.methodName == dropdownButton.text) {
                selectedPaymentMethod = paymentMethod
                break
            }
        }
        if (text == "USD") {
            walletContainer.isHidden = true
            uploadButton.isHidden = true
            return
        } else {
            walletContainer.isHidden = false
            uploadButton.isHidden = false
        }
        walletAddressTitle.text = "Your \(dropdownButton.text) Wallet:"
        walletNotice.text = "Your \(dropdownButton.text) must be sent from this wallet"
        
        setDropDownDataSource()
    }

    //MARK: - Call API
    func getWalletList() {
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        
        httpRequest(URLConstant.baseURL + URLConstant.userWallets, method: .get, parameters: nil, headers: headers) { json in
            let list = json["wallets"] as! [[String:Any]]
            for walletDic in list {
                let walletCategory = WalletCategory.init(dic: walletDic)
                self.walletList.append(walletCategory)
            }
            self.setDropDownDataSource()
        }
    }
    
    func addNewWallet() {
        guard !(walletAddress.text?.isEmpty)! else {
            return
        }
        let params = [
            "method_id" : selectedPaymentMethod!.methodId!,
            "wallet_address" : walletAddress.text!
            ] as [String:Any]
        
        let headers = [
            "token" : UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.addWallet, method: .post
        , parameters: params, headers: headers) { _ in
            self.gotoNext()
        }
    }
    
    func startUpload() {
        let params = [
            "citizenship" : UserDefaults.standard.string(forKey: UserProfiles.citizenship)!,
            "citizenship_id" : UserDefaults.standard.string(forKey: UserProfiles.citizenshipId)!,
            "passport_number" : UserDefaults.standard.string(forKey: UserProfiles.passportNumber)!,
            "country_of_residence" : UserDefaults.standard.string(forKey: UserProfiles.country)!
            ] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.object(forKey: UserProfiles.token) as! String
        ]
        httpUpload(endUrl: URLConstant.baseURL + URLConstant.uploadPassport, avatar: nil, passport: passportImage, parameters: params, headers: headers) { _ in
            self.makeToast("Uploaded passport")
            self.gotoNext()
        }
    }
    
    //MARK: - Get Image
    func getPassport() {
        let passportPicker = UIImagePickerController()
        passportPicker.delegate = self
        passportPicker.sourceType = .photoLibrary
        self.present(passportPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
       passportImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if (passportImage != nil) {
            uploadButton.setButtonIcon(image: passportImage!)
        } else {
            showMessage(title: "Pick Image Error", message: "Please choose another image!!")
        }
    }
    
    //MARK: - Listen to keyboard
    func listenToKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (walletAddress.isFirstResponder) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y = -(keyboardSize.height - 50)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        if (selectedPaymentMethod?.methodName == "USD") {
            gotoNext()
            return
        }
        for wallet in self.currentWalletList {
            if (wallet == walletAddress.text!) {
                gotoNext()
                return
            }
        }
        addNewWallet()
    }
    
    func gotoNext(){
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.TransactionDetailController) as! TransactionDetailController
        vc.project = project
        vc.paymentMethod = selectedPaymentMethod
        vc.walletAddress = walletAddress.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Dialog
    func showMessage(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
