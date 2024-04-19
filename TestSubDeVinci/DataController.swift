//
//  DataController.swift
//  TestSubDeVinci
//
//  Created by COURS on 19/04/2024.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error (error), (error.userInfo)")
            }
        }
    }
}
