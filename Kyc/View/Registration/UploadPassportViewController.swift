//
//  UploadPassportViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import DropDown
import DLRadioButton
import Alamofire

class UploadPassportViewController: ParticipateCommonController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, RoundViewDelegate, UploadButtonDelegate {
    //MARK: - Properties
    var imagePicker, passportPicker: UIImagePickerController!
    var selectedCitizenship: Int = 0
    var selectedCountry: Int = 0
    var citizenships: [CitizenshipModel] = []
    var countries: [CountryModel] = []
    var selfieImage, passportImage: UIImage!
    
    //MARK: - Outlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cameraButton: RoundView!
    @IBOutlet weak var btnSelectCitizenship: DropDownButton!
    @IBOutlet weak var btnSelectCoutry: DropDownButton!
    @IBOutlet weak var passportTextField: UITextField!
    @IBOutlet weak var accuracyCheckbox: DLRadioButton!
    @IBOutlet weak var termOfUseCheckbox: DLRadioButton!
    @IBOutlet weak var submitImageButton: ImageButton!
    @IBOutlet weak var uploadButton: UploadButton!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        getCitizenshipList()
    }
    
    //MARK: - Custom views
    override func customViews() {
        accuracyCheckbox.isMultipleSelectionEnabled = true
        passportTextField.delegate = self
        submitImageButton.delegate = self
        setupCameraButton()
    }
    
    func setupCameraButton() {
        uploadButton.delegate = self
        cameraButton.clickable = true
        cameraButton.delegate = self
        cameraButton.setImage(image: #imageLiteral(resourceName: "camera"))
    }
    
    func clickRoundView() {
        takeSelfie()
    }
    
    func clickUploadButton(sender: Any) {
        getPassport()
    }
    
    func setupCountryDropDown(countries: [CountryModel]) {
        
        var countryList = [String]()
        for country in countries {
            countryList.append(country.country)
        }
        btnSelectCoutry.setDataSource(source: countryList)
    }
    
    func setupCitizenshipDropDown(citizenships: [CitizenshipModel]){
        var citizenshipList = [String]()
        for citizenship in citizenships {
            citizenshipList.append(citizenship.nationality)
        }
        btnSelectCitizenship.setDataSource(source: citizenshipList)
    }
    
    
    override func imageButtonClick(_ sender: Any) {
//        gotoRegistrationCompletion()
        submit()
        //FIXME: submit here
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
    func submit() {
        if (passportTextField.text!.isEmpty) {
            showMessage(title: "Input error", message: "Passport cannot be empty")
            return
        }
        if(!accuracyCheckbox.isSelected || !termOfUseCheckbox.isSelected) {
            showMessage(title: "Agreement", message: "You have to agree with Accuracy and Terms of Use")
            return
        }
        let params = [
            "citizenship" : citizenships[selectedCitizenship].nationality,
            "citizenship_id" : citizenships[selectedCitizenship].id,
            "passport_number" : passportTextField.text!,
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
                    let json = response.result.value as! [String:Any]
                    let resultCode = json["code"] as! Int
                    if (resultCode == 200) {
                        self.activityIndicator.stopAnimating()
                        self.gotoRegistrationCompletion()
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
    
   
    //MARK: - Take photo and got image
    func getPassport() {
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
            showMessage(title: "Error", message: "This device doesn't have camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if (picker == imagePicker) {
            selfieImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            cameraButton.setPhoto(image: selfieImage)
        } else {
            passportImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            if (passportImage != nil) {
                uploadButton.setButtonIcon(image: passportImage)
            } else {
                showMessage(title: "Pick Image Error", message: "Please choose another image!!")
            }
        }
    }
    
    
    
    //MARK: - Navigations
    func gotoRegistrationCompletion() {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.CompleteRegisterViewController) as! CompleteRegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK: - Dialog
    func showMessage(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
 
}
