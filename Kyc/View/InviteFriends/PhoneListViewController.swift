//
//  PhoneListViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/18/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import Contacts

class PhoneListViewController: UIViewController, UITableViewDataSource {
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    var contacts: [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getContacts()
    }

    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as! PhoneCell
        cell.contactLabel.text = contacts[indexPath.row].contactName
        return cell
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
