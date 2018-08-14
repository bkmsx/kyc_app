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

class PhoneListViewController: ParticipateCommonController, UITableViewDataSource, PhoneCellDelegate, MFMessageComposeViewControllerDelegate, UITableViewDelegate, SelectAllDelegate {
    
    
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var contacts: [ContactModel] = []
    var selectedContacts: [ContactModel] = []
    var selectAll: Int = 0 {
        didSet {
            if (selectAll == 1) {
                selectAllView?.setChecked(true)
            } else {
                selectAllView?.setChecked(false)
            }
        }
    }
    var selectAllView: SelectAll?
    
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
        if (selectAll == 1) {
            cell.setCheck(true)
        } else if (selectAll == 2) {
            cell.setCheck(false)
        }
        cell.contact = contacts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        selectAllView = SelectAll.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 50))
        selectAllView?.delegate = self
        selectAllView?.setChecked(selectAll == 1)
        return selectAllView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
        if (selectedContacts.count == contacts.count) {
            selectAll = 1
        } else {
            selectAll = 0
        }
        phoneLabel.text = String(selectedContacts.count)
    }
    
    func toggleSellectAll(_ select: Bool) {
        if (select) {
            selectAll = 1
            selectedContacts.removeAll()
            selectedContacts.append(contentsOf: contacts)
        } else {
            selectAll = 2
            selectedContacts.removeAll()
        }
        phoneLabel.text = String(selectedContacts.count)
        tableView.reloadData()
    }
    
    //MARK: - Navigations
    @IBAction func sendInvitations(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Please join us by install KYC app to get free tokens"
            controller.recipients = []
            for contact in selectedContacts {
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
