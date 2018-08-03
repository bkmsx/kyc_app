//
//  WalletInputController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class WalletInputController: ParticipateCommonController, UploadButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DropDownButtonDelegate {
    var project: ProjectModel?
    var selectedPaymentMethod: PaymentMethodModel?
    var passportImage: UIImage?
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var walletAddress: UITextField!
    @IBOutlet weak var uploadButton: UploadButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dropdownButton: DropDownButton!
    @IBOutlet weak var walletAddressTitle: UILabel!
    @IBOutlet weak var walletNotice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyBoard()
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "NEXT")
        header.setSelectIndicator(index: 1)
        
        uploadButton.delegate = self
        uploadButton.isHidden = UserDefaults.standard.string(forKey: UserProfiles.passportPhoto) != nil
        
        roundView.setImage(image: #imageLiteral(resourceName: "check"))
        walletAddress.layer.cornerRadius = walletAddress.frame.size.height / 2
        walletAddress.clipsToBounds = true
        walletAddress.text = UserDefaults.standard.string(forKey: UserProfiles.erc20Address)
        
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
            didSelectDropDown(text: paymentMethods[0])
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        if (passportImage != nil) {
            startUpload()
        } else {
            gotoNext()
        }
    }
    
    //MARK: - Delegate
    func didSelectDropDown(text: String) {
        walletAddressTitle.text = "Your \(dropdownButton.text) Wallet:"
        walletNotice.text = "Your \(dropdownButton.text) must be sent from this wallet"
        for paymentMethod in (project?.paymentMethods)! {
            if (paymentMethod.methodName == dropdownButton.text) {
                selectedPaymentMethod = paymentMethod
                break
            }
        }
    }
    
    //MARK: - Upload Passport
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
        uploadPassport(endUrl: URLConstant.baseURL + URLConstant.uploadPassport, avatar: nil, passport: passportImage, parameters: params, headers: headers)
    }
    
    func uploadPassport(endUrl: String, avatar: UIImage?, passport: UIImage?, parameters: [String : Any], headers: HTTPHeaders){
        activityIndicator.startAnimating()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let avatar = avatar{
                let data = UIImageJPEGRepresentation(avatar, 0.5)!
                multipartFormData.append(data, withName: "selfie_photo", fileName: "selfie.jpeg", mimeType: "image/jpeg")
            }
            
            if let passport = passport {
                let data = UIImageJPEGRepresentation(passport, 0.5)!
                multipartFormData.append(data, withName: "passport_photo", fileName: "passport.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: endUrl, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = response.result.value as! [String:Any]
                    let resultCode = json["code"] as! Int
                    if (resultCode == 200) {
                        self.activityIndicator.stopAnimating()
                        self.gotoNext()
                    } else {
                        let message = json["message"] as! String
                        self.showMessage(title: "Upload Error", message: message)
                    }
                }
            case .failure(_):
                self.showMessage(title: "Upload Error", message: "Please try upload later")
            }
        }
    }
    
    func clickUploadButton(sender: Any) {
        getPassport()
    }
    
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
    

    //MARK: - Goto next
    func gotoNext(){
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.TransactionDetailController) as! TransactionDetailController
        vc.project = project
        vc.paymentMethod = selectedPaymentMethod
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Listen to keyboard
    func listenToKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (walletAddress.isFirstResponder) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= (keyboardSize.height - 50)
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
    
    //MARK: - Dialog
    func showMessage(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
