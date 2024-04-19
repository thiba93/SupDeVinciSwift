//
//  AppDelegate.swift
//  TestSubDeVinci
//
//  Created by COURS on 19/04/2024.
//

import Foundation
import CoreData

func createUser(username: String, firstName: String, lastName: String, password: String) {
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as! User

    user.username = username
    user.firstName = firstName
    user.lastName = lastName
    user.passwordHash = hashPassword(password) // Assume hashPassword est une fonction que vous avez définie pour hasher les mots de passe

    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}
