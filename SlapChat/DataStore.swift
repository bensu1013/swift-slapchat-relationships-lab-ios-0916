//
//  DataStore.swift
//  SlapChat
//
//  Created by Ian Rahman on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    var messages:[Message] = []
    var recipients:[Recipient] = []
    
    static let sharedInstance = DataStore()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SlapChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Fetching support
    
    func fetchData() {
        let context = persistentContainer.viewContext
        let messagesRequest: NSFetchRequest<Message> = Message.fetchRequest()
        let recipientRequest: NSFetchRequest<Recipient> = Recipient.fetchRequest()
        context.reset()
        do {
            messages = try context.fetch(messagesRequest)
            messages.sort { return ($0.createdAt as! Date) > ($1.createdAt as! Date) }
            
            recipients = try context.fetch(recipientRequest)
            
        } catch let error {
            print("Error fetching data: \(error)")
            messages = []
            recipients = []
        }
        
        if messages.count == 0 {
            generateTestData()
        }
    }
    
    // MARK: - Core Data generation of test data
    
    func delete(message: Message) {
        let context = persistentContainer.viewContext
        
        context.delete(message)
        
        saveContext()
        
    }
    
    func generateTestData() {
        
        let context = persistentContainer.viewContext
        
        let recipientOne = Recipient(context: context)
        recipientOne.name = "Jim"
        recipientOne.email = "jimjim@jimmy.jim"
        recipientOne.phoneNumber = 1231231234
        recipientOne.twitterHandle = "jimbo@heckler"
        
        
        let recipientTwo = Recipient(context: context)
        recipientTwo.name = "Longbottom"
        recipientTwo.email = "lb@gone.com"
        recipientTwo.phoneNumber = 1234567890
        recipientTwo.twitterHandle = "lb@shortie"
        
        
        let messageOne = Message(context: context)
        messageOne.content = "Message 1"
        messageOne.createdAt = NSDate()
        messageOne.recipient = recipientOne
        
        
        let messageTwo = Message(context: context)
        messageTwo.content = "Message 2"
        messageTwo.createdAt = NSDate()
        messageTwo.recipient = recipientOne
        
        
        let messageThree = Message(context: context)
        messageThree.content = "Message 3"
        messageThree.createdAt = NSDate()
        messageThree.recipient = recipientTwo
        
        
        let messageFour = Message(context: context)
        messageFour.content = "Jello"
        messageFour.createdAt = NSDate()
        messageFour.recipient = recipientTwo
        
        saveContext()
        fetchData()
    }
    
}
