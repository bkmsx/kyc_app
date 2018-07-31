//
//  TransactionDetailController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/26/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class TransactionDetailController: ParticipateCommonController {
    var project: ProjectModel?
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var header: ParticipateHeader!
    @IBOutlet weak var tokenNumber: UITextField!
    @IBOutlet weak var ethAmount: UILabel!
    @IBOutlet weak var usdAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyBoard()
    }

    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "SUBMIT")
        header.setSelectIndicator(index: 2)
        header.setCompanyLogo(link: (project?.logo)!)
        header.setProjectTitle(title: (project?.title?.uppercased())!)
        tokenNumber.layer.cornerRadius = tokenNumber.frame.size.height / 2
        tokenNumber.layer.borderWidth = 1
        tokenNumber.layer.borderColor = UIColor.init(argb: Colors.lightBlue).cgColor
        tokenNumber.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        countAmount()
    }
    
    @objc func textFieldDidChanged() {
        countAmount()
    }
    
    func countAmount() {
        ethAmount.text = "\(Float(tokenNumber.text!)! / 1000)"
        usdAmount.text = "US$\(Float(tokenNumber.text!)! * 453 / 1000)"
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        gotoNext()
    }
    
    //MARK: - Go to next
    func gotoNext() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SuccessTransactionViewController) as! SuccessTransactionViewController
        vc.project = project
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Listen to keyboard
    func listenToKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (tokenNumber.isFirstResponder) {
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
    
}
