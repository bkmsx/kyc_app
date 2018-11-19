//
//  UpdatePassportViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/19/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import DropDown

class UpdatePassportViewController: ParticipateCommonController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadButtonDelegate, RoundViewDelegate {
    //MARK: - Properties
    var passportPicker: UIImagePickerController!
    var imagePicker: UIImagePickerController!
    var selfieImage: UIImage!
    var passportImage: UIImage!
    var citizenships = [CitizenshipModel]()
    var countries = [CountryModel]()
    var passportVerified: String!
    var countryCode: String?
    var phoneNumber: String?
    
    //MARK: - Outlet
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var citizenshipDropDown: DropDownButton!
    @IBOutlet weak var countryDropDown: DropDownButton!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var uploadButton: UploadButton!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var dateBirthPicker: TextFieldBottomBorder!
    @IBOutlet weak var phoneCodeTextField: TextFieldPicker!
    @IBOutlet weak var mobileTextField: TextFieldBottomBorder!
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        getCitizenshipList()
    }
    
    //MARK: - Custom views
    override func customViews() {
        imageButton.delegate = self
        imageButton.setButtonTitle(title: "UPDATE")
        roundView.setImage(image: #imageLiteral(resourceName: "camera"))
        roundView.delegate = self
        if let passportNumber = UserDefaults.standard.string(forKey: UserProfiles.passportNumber) {
            passportNumberTextField.text = passportNumber
        }
        if let dateBirth = UserDefaults.standard.string(forKey: UserProfiles.dateOfBirth) {
            dateBirthPicker.text = dateBirth
        }
        if let phoneCode = UserDefaults.standard.string(forKey: UserProfiles.countryCode) {
            phoneCodeTextField.text = "+\(phoneCode)"
        } else {
            let regionCode = Locale.current.regionCode!
            if let index = Configs.COUNTRY_ISO.index(of: regionCode) {
                phoneCodeTextField.text = Configs.PHONE_CODES[index]
            }
        }
        if let mobileNumber = UserDefaults.standard.string(forKey: UserProfiles.phoneNumber) {
            mobileTextField.text = mobileNumber
        }
        uploadButton.delegate = self
        passportVerified = UserDefaults.standard.string(forKey: UserProfiles.passportVerified)!
        
        if (passportVerified == "1") {
            informationLabel.isHidden = false
            photoView.isHidden = true
        } else {
            informationLabel.isHidden = true
            photoView.isHidden = false
        }
    }
    
    //MARK: - Events
    func clickUploadButton(sender: Any) {
        getPassportImage()
    }
    
    @IBAction func chooseDateBirth(_ sender: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeIntervalSince1970: 1514721540)
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
  
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateBirthPicker.text = dateFormatter.string(from: sender.date)
    }
    
    func clickRoundView() {
        takeSelfie()
    }
    
    override func imageButtonClick(_ sender: Any) {
        
        if (passportVerified == "1") {
            showMessages("We are in the process of verifying your passport details")
            return
        }
        if (passportNumberTextField.text! == "") {
            showMessages("Please input passport number")
            return
        }
        if (dateBirthPicker.text! == "") {
            showMessages("Please choose date of birth")
            return
        }
        if (mobileTextField.text! == "") {
            showMessages("Please input phone number")
            return
        }
        if (passportImage == nil) {
            showMessages("Please choose passport image")
            return
        }
        
        
        sendOTPCode()
    }
    
    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    func gotoOTPVerification() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.OTPUpdatePassportController) as! OTPUpdatePassportController
        vc.countryCode = self.countryCode
        vc.phoneNumber = self.phoneNumber
        vc.citizenship = citizenshipDropDown.text
        vc.country = countryDropDown.text
        vc.passportNumber = passportNumberTextField.text
        vc.dob = dateBirthPicker.text
        vc.citizenshipId = citizenships[citizenshipDropDown.index].id
        vc.passportImage = passportImage
        vc.selfieImage = selfieImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Setup citizenship and country
    func setupCountryDropDown(countries: [CountryModel]) {
        var countryList = [String]()
        for country in countries {
            countryList.append(country.country)
        }
        countryDropDown.setDataSource(source: countryList)
        if let country = UserDefaults.standard.string(forKey: UserProfiles.country) {
            countryDropDown.setSelection(item: country)
        }
    }
    
    func setupCitizenshipDropDown(citizenships: [CitizenshipModel]){
        var citizenshipList = [String]()
        for citizenship in citizenships {
            citizenshipList.append(citizenship.nationality)
        }
        citizenshipDropDown.setDataSource(source: citizenshipList)
        if let citizenship = UserDefaults.standard.string(forKey: UserProfiles.citizenship) {
            citizenshipDropDown.setSelection(item: citizenship)
        }
    }
    
    //MARK: - Pick images
    func getPassportImage() {
        passportPicker = UIImagePickerController()
        passportPicker.delegate = self
        passportPicker.sourceType = .photoLibrary
        self.present(passportPicker, animated: true, completion: nil)
    }
    
    func takeSelfie() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            showMessage("This device doesn't support camera"){_ in }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if (picker == imagePicker) {
            selfieImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            if let selfieImage = selfieImage {
                roundView.setPhoto(image: selfieImage)
            }
        } else {
            passportImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            if let passportImage = passportImage {
                uploadButton.setButtonIcon(image: passportImage)
            }
        }
    }
    
    //MARK: - Call API
    func getCitizenshipList() {
        httpRequest(URLConstant.baseURL + URLConstant.citizenshipList) { (json) in
            let citizenshipArray = json["citizenships"] as! [[String:Any]]
            for citizenship in citizenshipArray {
                self.citizenships.append(CitizenshipModel(dictionary: citizenship))
            }
            let countryArray = json["countries"] as! [[String:Any]]
            for country in countryArray {
                self.countries.append(CountryModel(dictionary: country))
            }
            self.setupCitizenshipDropDown(citizenships: self.citizenships)
            self.setupCountryDropDown(countries: self.countries)
        }
    }
    
    func sendOTPCode(){
        let currenTime = Int(Date().timeIntervalSince1970)
        let otpTime = UserDefaults.standard.integer(forKey: UserProfiles.OTPTime)
        countryCode = phoneCodeTextField.text!
        let index = countryCode!.index(countryCode!.startIndex, offsetBy: 1)
        countryCode = String(countryCode![index...])
        phoneNumber = mobileTextField.text!
        if ((currenTime - otpTime) < 60){
            print("Go straight!!!")
            self.gotoOTPVerification()
            return
        }
        guard let phoneNumber = phoneNumber, let countryCode = countryCode else {
            return
        }
        let params = [
            "country_code" : countryCode,
            "phone_number" : phoneNumber,
            "via" : "sms"
            ] as [String : Any]
        httpRequest(URLConstant.baseURL + URLConstant.sendOTP, method: .post, parameters: params, headers: nil) { _ in
            let currentTime = Int(Date().timeIntervalSince1970)
            UserDefaults.standard.set(currentTime, forKey: UserProfiles.OTPTime)
            self.gotoOTPVerification()
        }
    }
    
    //MARK: - Dialog
    func showMessage(_ message: String, _ handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController.init(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
