//
//  AdminView.swift
//  TestSubDeVinci
//
//  Created by COURS on 19/04/2024.
//

import SwiftUI

struct AdminView: View {
    @Binding var isUserLoggedIn: Bool
    // Les données à afficher dans la grille
    let data = Array(1...20)  // 20 éléments pour remplir un tableau de 10x2

    // Définition des colonnes pour notre grille
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    Text("\(item)")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    @State static var isUserLoggedInPreview: Bool = false
    static var previews: some View {
        AdminView(isUserLoggedIn: $isUserLoggedInPreview)
    }
}
