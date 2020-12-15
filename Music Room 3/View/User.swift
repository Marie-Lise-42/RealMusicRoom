//
//  User.swift
//  Music Room 3
//
//  Created by ML on 04/12/2020.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    static var user: [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        guard let ourUser = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return ourUser
    }
    
}
