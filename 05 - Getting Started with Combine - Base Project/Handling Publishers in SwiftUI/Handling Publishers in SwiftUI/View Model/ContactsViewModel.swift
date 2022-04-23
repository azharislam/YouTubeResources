//
//  ContactsViewModel.swift
//  Handling Publishers in SwiftUI
//
//  Created by Azhar Islam on 23/04/2022.
//

import Combine

final class ContactsViewModel: ObservableObject {
    
    @Published private(set) var contacts = [Contact]()
    
    func add(contact: Contact) {
        contacts.append(contact)
    }
}
