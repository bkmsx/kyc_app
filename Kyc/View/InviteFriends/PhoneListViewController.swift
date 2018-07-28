//
//  PhoneListViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Contacts

class PhoneListViewController: ParticipateCommonController, UITableViewDataSource, PhoneCellDelegate {
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
        navigationController?.popViewController(animated: true)
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
