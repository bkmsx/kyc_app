//
//  CommonViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class CommonViewController: UIViewController {
    var activityIndicatorView: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
        setupActivityIndicator()
    }
    
    func customViews() {
        
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
    
    //MARK: - Dialog
    func showMessages(message: String) {
        let alert = UIAlertController.init(title: "Input error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - HTTP request
    func httpRequest(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, success: @escaping (_ json: [String:Any]) -> Void) {
        self.activityIndicatorView?.startAnimating()
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            self.activityIndicatorView?.stopAnimating()
            switch (response.result) {
            case .success(_):
                let json = response.result.value as! [String:Any]
                let code = json["code"] as? Int ?? 404
                if (code == 200) {
                    success(json)
                } else {
                    self.showMessages(message: json["message"] as! String)
                }
                break
            case .failure(_):
                self.showMessages(message: "There is an error")
                break
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
