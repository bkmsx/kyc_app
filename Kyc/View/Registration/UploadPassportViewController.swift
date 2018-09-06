//
//  UploadPassportViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/29/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class UploadPassportViewController: ParticipateCommonController {
    //MARK: - Properties
    var imagePicker, passportPicker: UIImagePickerController!
    var selectedCitizenship: Int = 0
    var selectedCountry: Int = 0
    var citizenships: [CitizenshipModel] = []
    var countries: [CountryModel] = []
    var selfieImage, passportImage: UIImage!
    
    //MARK: - Outlet
    @IBOutlet weak var btnSelectCitizenship: DropDownButton!
    @IBOutlet weak var btnSelectCoutry: DropDownButton!
    @IBOutlet weak var accuracyCheckbox: Checkbox!
    @IBOutlet weak var termOfUseCheckbox: Checkbox!
    @IBOutlet weak var submitImageButton: ImageButton!
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        getCitizenshipList()
    }
    
    //MARK: - Custom views
    override func customViews() {
        submitImageButton.delegate = self
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
    
    //MARK: - Events
    @IBAction func showTermsOfUse(_ sender: Any) {
        let dialog = TermConditionDialog("https://novum.capital")
        dialog.show(animated: true)
    }
    
    override func imageButtonClick(_ sender: Any) {
        if(!accuracyCheckbox.isChecked || !termOfUseCheckbox.isChecked) {
            showMessage(title: "Agreement", message: "You have to agree with Accuracy and Terms of Use")
            return
        }
        submit()
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
        let params = [
            "citizenship" : citizenships[selectedCitizenship].nationality,
            "citizenship_id" : citizenships[selectedCitizenship].id,
            "passport_number" : "BB",
            "country_of_residence" : countries[selectedCountry].country
            ] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.object(forKey: UserProfiles.token) as! String
        ]
        httpUpload(endUrl: URLConstant.baseURL + URLConstant.uploadPassport, avatar: selfieImage, passport: passportImage, parameters: params, headers: headers) { _ in
            self.gotoRegistrationCompletion()
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
