//
//  EurekaHelper.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-28.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI
import Eureka

/*
public class ContactCellOf<T: Equatable>: Cell<T>, CellType, CNContactPickerDelegate {
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    public override func setup(){
        super.setup()
        self.bindContact()
    }
    
    
    public override func update() {
        super.update()
        self.bindContact()
    }
    
    
    private func bindContact(){
        switch CNContactStore.authorizationStatusForEntityType(.Contacts){
        case .Authorized: //Update our UI if the user has granted access to their Contacts
            selectionStyle = row.isDisabled ? .None : .Default
            
            if let id = self.row.value as? String, let contact = contactFromIdentifier(id){
                detailTextLabel?.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
            }
            
        case .NotDetermined: //Prompt the user for access to Contacts if there is no definitive answer
            CNContactStore().requestAccessForEntityType(.Contacts) { granted, error in
                dispatch_async(dispatch_get_main_queue()){
                    self.row.disabled = Condition.init(booleanLiteral: !granted)
                    self.selectionStyle = self.row.isDisabled ? .None : .Default
                    
                    if granted, let id = self.row.value as? String, let contact = self.contactFromIdentifier(id){
                        self.detailTextLabel?.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
                    }
                }
            }
            
        case .Denied, .Restricted:
            self.row.disabled = true
            selectionStyle = row.isDisabled ? .None : .Default
        }
    }
    
    
    private func contactFromIdentifier(identifier: String) -> CNContact?{
        do{
            return try CNContactStore().unifiedContactWithIdentifier(identifier, keysToFetch: [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)])
            
        } catch let error as NSError{
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    
    public override func didSelect() {
        super.didSelect()
        
        let controller = CNContactPickerViewController()
        controller.delegate = self
        
        self.formViewController()?.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    public func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty){
        if contactProperty.contact.isKeyAvailable(CNContactIdentifierKey), let id = contactProperty.contact.valueForKey(CNContactIdentifierKey) as? T{
            self.row.value = id
            
        } else {
            self.row.value = nil
        }
    }
}
public typealias ContactCell = ContactCellOf<String>
 */
