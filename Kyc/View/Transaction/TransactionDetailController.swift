//
//  TransactionDetailController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Alamofire

class TransactionDetailController: ParticipateCommonController {
    //From previous
    var project: ProjectModel?
    var paymentMethod: PaymentMethodModel?
    var walletAddress: String?

    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var tokenNumber: UITextField!
    @IBOutlet weak var ethAmount: UILabel!
    @IBOutlet weak var tokenPrice: UILabel!
    @IBOutlet weak var totalAmountTitle: UILabel!
    @IBOutlet weak var referralCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyBoard()
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SUBMIT")
        header.setSelectIndicator(index: 2)
        if let project = project {
            header.setCompanyLogo(link: (project.logo)!)
            header.setProjectTitle(title: (project.title?.uppercased())!)
            tokenPrice.text = "1 TOKEN = \(paymentMethod!.price!) \(paymentMethod!.methodName!)"
            totalAmountTitle.text = "Total \(paymentMethod!.methodName!) amount:"
        }
        tokenNumber.layer.cornerRadius = tokenNumber.frame.size.height / 2
        tokenNumber.layer.borderWidth = 1
        tokenNumber.layer.borderColor = UIColor.init(argb: Colors.lightBlue).cgColor
        tokenNumber.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        referralCode.setBottomBorder(color: UIColor.init(argb: Colors.lightBlue))
        countAmount()
    }
    
    @objc func textFieldDidChanged() {
        countAmount()
    }
    
    func countAmount() {
        let price = Float(paymentMethod!.price!)!
        if (tokenNumber.text! == "") {
            ethAmount.text = "0"
        } else {
            let tokens = tokenNumber.text!
            if (tokens.matches("^[+-]?([0-9]*[.])?[0-9]+$")) {
                var amountFormat = "%.10f";
                if (paymentMethod?.methodName! == "USD") {
                    amountFormat = "%.2f";
                }
                ethAmount.text = String(format: amountFormat,  Float(tokens)! * price)
            } else {
                ethAmount.text = "0"
            }
        }
    }
    
    //MARK: - Call API
    override func imageButtonClick(_ sender: Any) {
        guard let project = project, let method = paymentMethod, let walletAddress = walletAddress else {return}
        if (method.methodName! == "ETH") {
            makePurchase(1, project, method, walletAddress)
            return
        }
        var symbol = method.methodName!
        var convert = "ETH"
        if (symbol == "USD") {
            symbol = "ETH"
            convert = "USD"
        }
        
        let params = [
            "symbol": symbol as Any,
            "convert": convert as Any
        ]
       
        let headers = [
            "X-CMC_PRO_API_KEY": "1046459a-6062-41e8-8f48-f8253ed4f81d"
        ]
        
        httpRequest("https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest", parameters: params, headers: headers, code200: false) { json in
            guard let data = json["data"] as? [String:Any] else {
                self.doNotSupportCurrency()
                return
            }
            guard let currency = data[symbol] as? [String:Any] else {
                self.doNotSupportCurrency()
                return
            }
            guard let quote = currency["quote"] as? [String:Any] else {
                self.doNotSupportCurrency()
                return
            }
            guard let ETH = quote[convert] as? [String:Any] else {
                self.doNotSupportCurrency()
                return
            }
            guard let price = ETH["price"] as? Double else {
                self.doNotSupportCurrency()
                return
            }
            if (convert == "USD") {
                self.makePurchase(1 / price, project, method, walletAddress)
            } else {
                self.makePurchase(price, project, method, walletAddress)
            }
        }
        
    }
    
    func doNotSupportCurrency() {
        self.showMessages("Do not support this currency right now. Please select ETH payment method.")
    }
    
    func makePurchase(_ price: Double, _ project: ProjectModel, _ method: PaymentMethodModel, _ walletAddress: String) {
        print(price)
        let amount = Double(ethAmount.text!)!
        let params = [
            "project_id": project.projectId! as Any,
            "payment_method" : method.methodName! as Any,
            "payment_method_id" : method.methodId! as Any,
            "amount_tokens" : tokenNumber.text! as Any,
            "payment_amount" : ethAmount.text! as Any,
            "discount" : project.currentDiscount ?? "0",
            "wallet_address" : walletAddress as Any,
            "referral_code" : referralCode.text! as Any,
            "payment_amount_eth" : String(amount * price) as Any
        ]
        let headers = [
            "token": UserDefaults.standard.string(forKey: UserProfiles.token)!
        ]
        httpRequest(URLConstant.baseURL + URLConstant.participate, method: .post, parameters: params, headers: headers) { _ in
            self.gotoNext()
        }
    }
    
    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    func gotoNext() {
        if let paymentMethod = paymentMethod, paymentMethod.methodName == "USD" {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.USDDetailViewController) as! USDDetailViewController
            vc.project = project
            vc.paymentMethod = paymentMethod
            vc.amount = ethAmount.text
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SuccessTransactionViewController) as! SuccessTransactionViewController
            vc.project = project
            vc.paymentMethod = paymentMethod
            vc.amount = ethAmount.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Listen to keyboard
    func listenToKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (tokenNumber.isFirstResponder || referralCode.isFirstResponder) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= (keyboardSize.height - 120)
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
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
