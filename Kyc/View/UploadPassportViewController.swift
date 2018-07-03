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

class UploadPassportViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker, passportPicker: UIImagePickerController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var btnSelectCitizenship: UIButton!
    
    @IBOutlet weak var accuracySelection: DLRadioButton!
    
    @IBAction func selectCitizenship(_ sender: Any) {
        citizenshipDropDown.show()
    }
    
    @IBAction func selectCheckbox(_ sender: Any) {
    }
    
    @IBAction func getPassport(_ sender: Any) {
        passportPicker = UIImagePickerController()
        passportPicker.delegate = self
        passportPicker.sourceType = .photoLibrary
        self.present(passportPicker, animated: true, completion: nil)
    }
    
    @IBAction func takeSelfie(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if (picker == imagePicker) {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        } else {
            print("got passport")
        }
    }
    
    let citizenshipDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCitizenshipList()
        accuracySelection.isMultipleSelectionEnabled = true
    }
    
    func getCitizenshipList() {
        Alamofire.request(URLConstant.baseURL + URLConstant.citizenshipList, method: .get, parameters: nil)
            .responseData { response in
                let result = try? JSONDecoder().decode(Citizeships.self, from: response.result.value!)
                self.setupDropDown(citizenships: (result?.citizenships)!)
        }
    }

    func setupDropDown(citizenships: [Citizenship]){
        citizenshipDropDown.anchorView = btnSelectCitizenship
        citizenshipDropDown.bottomOffset = CGPoint.init(x: 0, y: btnSelectCitizenship.bounds.height)
        citizenshipDropDown.selectionAction = { [weak self](index, item) in
            self?.btnSelectCitizenship.setTitle(item, for: .normal)
            
        }
        
        var citizenshipList = [String]()
        for citizenship in citizenships {
            citizenshipList.append(citizenship.nationality)
        }
        citizenshipDropDown.dataSource = citizenshipList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
