//
//  CoreDataHelper.swift
//  SwiftUIDemo
//
//  Created by Chrishon Wyllie on 4/16/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    // C
    
    static func addCustomer(_ customerName: String, context: NSManagedObjectContext) {
        let newCustomer = Customer(context: context)
        newCustomer.id = UUID()
        newCustomer.numVisits = Int64(0)
        newCustomer.name = customerName
        newCustomer.dateAdded = Date()
    
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    // R
    
    static func getCustomer(with tagID: String, context: NSManagedObjectContext) -> Customer? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Customer")
        fetchRequest.predicate = NSPredicate(format: "name == %@", tagID as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let customers = try context.fetch(fetchRequest)
            return customers.first as? Customer
        } catch let error {
            print(error)
            return nil
        }
    }
    
    
    // U
  
    static func updateCustomer(_ customer: Customer, context: NSManagedObjectContext) {
        let previousNumberOfVisits = customer.numVisits
        let updatedValue = previousNumberOfVisits + 1
        
        context.performAndWait {
            customer.numVisits = updatedValue
            try? context.save()
        }
    }
    
    
    
    // D
    
}
