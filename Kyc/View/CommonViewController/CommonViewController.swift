//
//  CommonViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class CommonViewController: UIViewController, UITextFieldDelegate {
    var activityIndicatorView: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
        setupActivityIndicator()
        setupTextFields(self.view)
    }
    
    func customViews() {
        
    }
    
    func setupTextFields(_ view : UIView) {
        for subView in view.subviews {
            if subView is UITextField {
                (subView as! UITextField).delegate = self
            } else {
                if !(subView is UISearchBar) {
                    setupTextFields(subView)
                }
            }
        }
    }
    
    //MARK: - Activity Indicator
    func setupActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView.init(frame: CGRect.init(x: self.view.frame.size.width / 2 - 25, y: self.view.frame.size.height / 2 - 25, width: 50, height: 50))
        activityIndicatorView?.layer.zPosition = 1000
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView?.backgroundColor = UIColor.init(argb: Colors.lightBlue).withAlphaComponent(0.6)
        activityIndicatorView?.layer.cornerRadius = 10
        activityIndicatorView?.hidesWhenStopped = true
    }

    //MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Navigate back
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func goBackRootView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goBackSomeViewControllers(backNumber: Int) {
        let vcNumber = navigationController?.viewControllers.count
        let viewcontroller = navigationController?.viewControllers[vcNumber! - 1 - backNumber]
        navigationController?.popToViewController(viewcontroller!, animated: true)
    }
    
    //MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: - Dialog
    func showMessages(_ message: String) {
        let alert = UIAlertController.init(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Toast
    func makeToast(_ message: String) {
        var style = ToastStyle()
        style.messageAlignment = .center
        UIApplication.shared.keyWindow?.makeToast(message, position: .center, style: style)
    }
    
    //MARK: - HTTP request
    func httpRequest(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, success: @escaping (_ json: [String:Any]) -> Void) {
        print(parameters)
        DispatchQueue.main.async {
            self.activityIndicatorView?.startAnimating()
        }
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            DispatchQueue.main.async {
                self.activityIndicatorView?.stopAnimating()
            }
            switch (response.result) {
            case .success(_):
                let json = response.result.value as! [String:Any]
                let code = json["code"] as? Int ?? 404
                if (code == 200) {
                    success(json)
                } else {
                    self.showMessages(json["message"] as? String ?? "System error")
                }
                break
            case .failure(_):
                self.showMessages("Concordia needs an internet connection to work.")
                break
            }
        }
    }
    
    func httpUpload(endUrl: String, avatar: UIImage?, passport: UIImage?, parameters: [String : Any], headers: HTTPHeaders, success: @escaping (_ json: [String:Any]) -> Void){
        print(parameters)
        DispatchQueue.main.async {
            self.activityIndicatorView?.startAnimating()
        }
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
                    DispatchQueue.main.async {
                        self.activityIndicatorView?.stopAnimating()
                    }
                    let json = response.result.value as! [String:Any]
                    let resultCode = json["code"] as? Int ?? 404
                    if (resultCode == 200) {
                        success(json)
                    } else {
                        let message = json["message"] as! String
                        self.showMessages(message)
                    }
                }
            case .failure(_):
                self.showMessages("Please try upload later")
            }
        }
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
