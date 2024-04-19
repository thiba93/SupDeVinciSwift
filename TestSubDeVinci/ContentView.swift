    //
    //  ContentView.swift
    //  TestSubDeVinci
    //
    //  Created by Guillaume on 16/04/2024.
    //

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var registerUsername: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var registerPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isAdmin: Bool = false
    @State private var notation: Int = 0
    @State private var hasDoneTheEval: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isUserLoggedIn: Bool = false 
    @State private var isUserLoggedInPreview: Bool = false  
    @State private var showAdminView: Bool = false
    // État pour contrôler l'affichage de la vue de connexion
    
    
    var body: some View {
        if isUserLoggedIn && showAdminView {
            AdminView(isUserLoggedIn: $isUserLoggedInPreview )  // Afficher QCMView si l'utilisateur est connecté
        }  else if isUserLoggedIn {
            QCMView(isUserLoggedIn: $isUserLoggedInPreview)
        }else {
            
            VStack {
                loginSection
                Spacer() // Separates the login and registration sections
                registrationSection
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    var loginSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Connexion")
                .font(.largeTitle)
                .padding(.top, 50)
            
            TextField("Pseudonyme", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            TextField("Mot de passe", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            Button("Se connecter") {
                performLogin()
            }
            .buttonStyle(DefaultButtonStyle())
            .padding(.horizontal, 20)
        }
    }
    
    var registrationSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Créer un compte")
                .font(.headline)
                .padding(.top, 20)
            
            TextField("Pseudonyme", text: $registerUsername)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            TextField("Nom", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            TextField("Prénom", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            TextField("Mot de passe", text: $registerPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            TextField("Confirmer le mot de passe", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            Button("Créer un compte") {
                performRegistration()
            }
            .buttonStyle(DefaultButtonStyle())
            .padding(.horizontal, 20)
        }
    }
    
    //    private func performLogin() {
    //          if let user = users.first(where: { $0.username == username && $0.password == password }) {
    //              print("User \(user.firstName) \(user.lastName) logged in successfully!")
    //              isUserLoggedIn = true  // Mettre à jour l'état pour afficher QCMView
    //          } else {
    //              alertMessage = "Pseudonyme ou mot de passe invalide."
    //              showAlert = true
    //          }
    //      }
    //
    //    private func performRegistration() {
    //        guard registerPassword == confirmPassword else {
    //            alertMessage = "Les mots de passe ne correspondent pas."
    //            showAlert = true
    //            return
    //        }
    //
    //        guard !users.contains(where: { $0.username == registerUsername }) else {
    //            alertMessage = "Ce pseudonyme est déjà utilisé. Veuillez en choisir un autre."
    //            showAlert = true
    //            return
    //        }
    //
    //        let newUser = UserModel(id: UUID(), firstName: firstName, lastName: lastName, username: registerUsername, password: registerPassword, isAdmin: isAdmin, notation: notation, hasDoneTheEval: hasDoneTheEval)
    //        users.append(newUser)
    //        print("Account created for \(newUser.username)!")
    //    }
    //}
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    private func performRegistration() {
        guard registerPassword == confirmPassword else {
            alertMessage = "Les mots de passe ne correspondent pas."
            showAlert = true
            return
        }
        
        // Vérification du nombre d'utilisateurs avec le même pseudonyme
        let fetchRequest: NSFetchRequest<UserModel> = UserModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", registerUsername)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            if existingUsers.count >= 2 {
                alertMessage = "Il ne peut pas y avoir plus de deux utilisateurs avec le même pseudonyme."
                showAlert = true
                return
            }
        } catch {
            let nsError = error as NSError
            alertMessage = "Erreur lors de la vérification du pseudonyme : \(nsError.localizedDescription)"
            showAlert = true
            return
        }
        
        // Création d'un nouvel utilisateur
        let newUser = UserModel(context: context)
        newUser.username = registerUsername
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.isAdmin = isAdmin
        newUser.password = registerPassword
        
        do {
            try context.save()
            print("User added")
            print(newUser)
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            alertMessage = "Erreur lors de l'enregistrement de l'utilisateur."
            showAlert = true
        }
    }
    
    
    func fetchUser(byUsername username: String, andPassword password: String) -> UserModel? {
        let fetchRequest: NSFetchRequest<UserModel> = UserModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    
    // Ajout de la logique de redirection dans performLogin
    private func performLogin() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Les champs identifiant et mot de passe ne peuvent pas être vides."
            showAlert = true
            return
        }

        let user = fetchUser(byUsername: username, andPassword: password)
        if let user = user {
            isUserLoggedIn = true
            // Vérifier si l'utilisateur est l'administrateur
            if username == "Admin" {
                showAdminView = true  // Rediriger vers AdminView
            } else {
                showAdminView = false
            }
            print("Login successful for user: \(user.username)")
        } else {
            alertMessage = "La combinaison identifiant / mot de passe est incorrect."
            showAlert = true
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
