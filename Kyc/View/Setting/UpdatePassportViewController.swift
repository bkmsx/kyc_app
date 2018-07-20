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

class UpdatePassportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Properties
    var passportPicker: UIImagePickerController!
    var imagePicker: UIImagePickerController!
    var selfieImage: UIImage!
    var passportImage: UIImage!
    var citizenships = [CitizenshipModel]()
    var countries = [CountryModel]()
    var citizenshipDropDown = DropDown()
    var countryDropDown = DropDown()
    var selectedCitizenship: Int = 0
    var selectedCountry: Int = 0
    
    //MARK: - Outlet
    @IBOutlet weak var citizenshipDropDownButton: UIButton!
    @IBOutlet weak var countryDropDownButton: UIButton!
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        getCitizenshipList()
    }
    
    //MARK: - Setup citizenship and country
    
    @IBAction func selectCitizenship(_ sender: Any) {
        citizenshipDropDown.show()
    }
    @IBAction func selectCountry(_ sender: Any) {
        countryDropDown.show()
    }
    
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
                self.citizenshipDropDownButton.setTitle(self.citizenships[self.selectedCitizenship].nationality, for: .normal)
                self.countryDropDownButton.setTitle(self.countries[self.selectedCountry].country, for: .normal)
        }
    }
    
    func setupCountryDropDown(countries: [CountryModel]) {
        countryDropDown.anchorView = countryDropDownButton
        countryDropDown.bottomOffset = CGPoint.init(x: 0, y: countryDropDownButton.bounds.height)
        countryDropDown.selectionAction = { [weak self](index, item) in
            self?.countryDropDownButton.setTitle(item, for: .normal)
            self?.selectedCountry = index
        }
        
        var countryList = [String]()
        for country in countries {
            countryList.append(country.country)
        }
        countryDropDown.dataSource = countryList
    }
    
    func setupCitizenshipDropDown(citizenships: [CitizenshipModel]){
        citizenshipDropDown.anchorView = citizenshipDropDownButton
        citizenshipDropDown.bottomOffset = CGPoint.init(x: 0, y: citizenshipDropDownButton.bounds.height)
        citizenshipDropDown.selectionAction = { [weak self](index, item) in
            self?.citizenshipDropDownButton.setTitle(item, for: .normal)
            self?.selectedCitizenship = index
        }
        
        var citizenshipList = [String]()
        for citizenship in citizenships {
            citizenshipList.append(citizenship.nationality)
        }
        citizenshipDropDown.dataSource = citizenshipList
    }
    
    //MARK: - Pick images
    @IBAction func getPassportImage(_ sender: Any) {
        passportPicker = UIImagePickerController()
        passportPicker.delegate = self
        passportPicker.sourceType = .photoLibrary
        self.present(passportPicker, animated: true, completion: nil)
    }
    
    @IBAction func takeSelfie(_ sender: Any) {
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
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            selfieImage = imageView.image
        } else {
            passportImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    
    //MARK: - Update passport

    @IBAction func updatePassport(_ sender: Any) {
        if (selfieImage == nil && passportImage == nil) {
            showMessage(message: "Please take a picture")
            return
        }
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
                    self.navigationController?.popViewController(animated: true)
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
