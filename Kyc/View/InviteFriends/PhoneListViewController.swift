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

class PhoneListViewController: ParticipateCommonController, UITableViewDataSource, PhoneCellDelegate, MFMessageComposeViewControllerDelegate {
    
    
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneLabel: UILabel!
    var contacts: [ContactModel] = []
    var selectedCotacts: [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getContacts()
    }
    
    //MARK: - Custom views
    override func customViews() {
        phoneLabel.layer.cornerRadius = phoneLabel.frame.size.height / 2
        phoneLabel.clipsToBounds = true
    }
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as! PhoneCell
        cell.contact = contacts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //MARK: - TableView Delegate
    func changeChecked(contact: ContactModel, isChecked: Bool) {
        if (isChecked) {
            selectedCotacts.append(contact)
        } else {
            for index in 0...(selectedCotacts.count - 1) {
                if (contact.contactName == selectedCotacts[index].contactName) {
                    selectedCotacts.remove(at: index)
                    break
                }
            }
        }
        phoneLabel.text = String(selectedCotacts.count)
    }
    
    //MARK: - Send invitations
    @IBAction func sendInvitations(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Please join us by install KYC app to get free tokens"
            controller.recipients = []
            for contact in selectedCotacts {
                controller.recipients?.append(contact.contactNumber)
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            showMessages(message: "This device doesn't support SMS")
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
