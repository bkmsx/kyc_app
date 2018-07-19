//
//  ForgotPasswordViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 6/28/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = UserDefaults.standard.object(forKey: UserProfiles.phoneNumber) as? String ?? nil
        if (userId == nil) {
            print("There is no selfie")
        } else {
            print(userId!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
