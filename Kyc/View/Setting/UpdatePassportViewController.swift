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
    var selectedCitizenship: Int = 0
    var selectedCountry: Int = 0
    
    //MARK: - Outlet
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var citizenshipDropDown: DropDownButton!
    @IBOutlet weak var countryDropDown: DropDownButton!
    @IBOutlet weak var imageButton: ImageButton!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var uploadButton: UploadButton!
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
        roundView.clickable = true
        roundView.delegate = self
        passportNumberTextField.setBottomBorder(color: UIColor.init(argb: Colors.lightGray))
        passportNumberTextField.text = UserDefaults.standard.string(forKey: UserProfiles.passportNumber)!
        uploadButton.delegate = self
    }
    
    func clickUploadButton(sender: Any) {
        getPassportImage()
    }
    
    func clickRoundView() {
        takeSelfie()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    override func imageButtonClick(_ sender: Any) {
        updatePassport()
    }
    
    //MARK: - Setup citizenship and country
    func getCitizenshipList() {
        Alamofire.request(URLConstant.baseURL + URLConstant.citizenshipList, method: .get, parameters: nil)
            .responseJSON { response in
                let json = response.result.value as! [String:Any]
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
    
    func setupCountryDropDown(countries: [CountryModel]) {
       
        var countryList = [String]()
        for country in countries {
            countryList.append(country.country)
        }
        countryDropDown.setDataSource(source: countryList)
    }
    
    func setupCitizenshipDropDown(citizenships: [CitizenshipModel]){
        var citizenshipList = [String]()
        for citizenship in citizenships {
            citizenshipList.append(citizenship.nationality)
        }
        citizenshipDropDown.setDataSource(source: citizenshipList)
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
            showMessage(message: "This device doesn't support camera")
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
    
    //MARK: - Update passport

    func updatePassport() {
        let params = [
            "citizenship" : citizenships[selectedCitizenship].nationality,
            "citizenship_id" : citizenships[selectedCitizenship].id,
            "passport_number" : passportNumberTextField.text!,
            "country_of_residence" : countries[selectedCountry].country
            ] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.object(forKey: UserProfiles.token) as! String
        ]
        
        uploadPassport(endUrl: URLConstant.baseURL + URLConstant.uploadPassport, avatar: selfieImage, passport: passportImage, parameters: params, headers: headers)
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
                    self.activityIndicator.stopAnimating()
                    self.goBack()
                }
            case .failure(_):
                print("Not ok")
            }
        }
    }
    
    //MARK: - Dialog
    func showMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
