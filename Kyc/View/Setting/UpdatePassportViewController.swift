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
    
    //MARK: - Outlet
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var citizenshipDropDown: DropDownButton!
    @IBOutlet weak var countryDropDown: DropDownButton!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var uploadButton: UploadButton!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var photoView: UIView!
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
        if (passportImage == nil) {
            showMessages("Please choose passport image")
            return
        }
        updatePassport()
    }
    
    //MARK: - Navigation
    @IBAction func clickBack(_ sender: Any) {
        goBack()
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

    func updatePassport() {
        let citizenship = citizenshipDropDown.text
        let country = countryDropDown.text
        let passportNumber = passportNumberTextField.text!
        let params = [
            "citizenship" : citizenship,
            "citizenship_id" : citizenships[citizenshipDropDown.index].id,
            "passport_number" : passportNumber,
            "country_of_residence" : country
            ] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.object(forKey: UserProfiles.token) as! String
        ]
        httpUpload(endUrl: URLConstant.baseURL + URLConstant.uploadPassport, avatar: selfieImage, passport: passportImage, parameters: params, headers: headers) { json in
            UserDefaults.standard.set(citizenship, forKey: UserProfiles.citizenship)
            UserDefaults.standard.set(country, forKey: UserProfiles.country)
            UserDefaults.standard.set(passportNumber, forKey: UserProfiles.passportNumber)
            UserDefaults.standard.set("1", forKey: UserProfiles.passportVerified)
            self.showMessage("Thank you for updating your passport details. Please give us 3 business days to verify your account.") { _ in
                self.goBack()
            }
        }
    }
    
    //MARK: - Dialog
    func showMessage(_ message: String, _ handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController.init(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
