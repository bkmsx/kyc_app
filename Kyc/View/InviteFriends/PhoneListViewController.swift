//
//  PhoneListViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
import Toast_Swift

class PhoneListViewController: ParticipateCommonController, UITableViewDataSource, PhoneCellDelegate, MFMessageComposeViewControllerDelegate, UITableViewDelegate {
    //From previous
    var projectName: String?
    
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var contacts: [ContactModel] = []
    var selectedContacts: [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getContacts()
    }
    
    //MARK: - Custom views
    override func customViews() {
        phoneLabel.layer.cornerRadius = phoneLabel.frame.size.height / 2
        phoneLabel.clipsToBounds = true
        
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as! PhoneCell
        cell.contact = contacts[indexPath.row]
        if selectedContacts.contains(where: { $0.contactName == contacts[indexPath.row].contactName}) {
            cell.setCheck(true)
        } else {
            cell.setCheck(false)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func changeChecked(contact: ContactModel, isChecked: Bool) {
        if (isChecked) {
            selectedContacts.append(contact)
        } else {
            for index in 0...(selectedContacts.count - 1) {
                if (contact.contactName == selectedContacts[index].contactName) {
                    selectedContacts.remove(at: index)
                    break
                }
            }
        }
        phoneLabel.text = String(selectedContacts.count)
    }
    
    //MARK: - Navigations
    @IBAction func sendInvitations(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            if (selectedContacts.count > 10) {
                showMessages("You can only send up to 10 contacts at once")
                return
            }
            let controller = MFMessageComposeViewController()
            let referralCode = UserDefaults.standard.string(forKey: UserProfiles.referralCode)!
            if let projectName = projectName {
                controller.body = "Hey, participate in project: \"\(projectName)\" with referral code:\"\(referralCode)\" to get free token!"
            } else {
                controller.body = "Hey, install KYC app and register with this referral code: \"\(referralCode)\" to get free token! Site: https://www.concordia.ventures"
            }
            controller.recipients = []
            for contact in selectedContacts {
                controller.recipients?.append(contact.contactNumber)
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            showMessages("This device doesn't support SMS")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if (result == .cancelled || result == .failed) {
            UIApplication.shared.keyWindow?.makeToast("You are not successful to send invitations")

        } else {
            UIApplication.shared.keyWindow?.makeToast("You've sent invitations to friends")
        }
        
        controller.dismiss(animated: true, completion: nil)
        goBack()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - Contacts
    func getContacts(){
        let contactStore = CNContactStore()
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey
            ] as [Any]
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        var results: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keyToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        for contact in results {
            var contactName = ""
            var contactPhone = ""
            if (!contact.givenName.isEmpty) {
                contactName.append(contact.givenName)
                contactName.append(" ")
            }
            if (!contact.familyName.isEmpty) {
                contactName.append(contact.familyName)
            }
            
            if (contact.phoneNumbers.count > 0) {
                contactPhone = contact.phoneNumbers[0].value.stringValue
            }
            contacts.append(ContactModel(contactName: contactName, contactNumber: contactPhone))
        }
    }
}
