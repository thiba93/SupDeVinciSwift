//
//  QCMView.swift
//  TestSubDeVinci
//
//  Created by COURS on 19/04/2024.
//
import SwiftUI

struct QCMView: View {
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showScore = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var isUserLoggedIn: Bool
    let quizModel = Model()

    var body: some View {
        VStack {
            if showScore {
                logoutButton
                backButton
                Text("Votre score : \(score) / \(quizModel.questions.count)")
                    .font(.title)
            } else {
                Text(quizModel.questions[currentQuestionIndex].statement)
                    .font(.title)
                    .padding()

                ForEach(quizModel.questions[currentQuestionIndex].proposal.indices, id: \.self) { index in
                    Button(quizModel.questions[currentQuestionIndex].proposal[index]) {
                        answerSelected(index: index)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    var logoutButton: some View {
         Button("Se déconnecter") {
             self.isUserLoggedIn = false
             self.presentationMode.wrappedValue.dismiss()
         }
         .padding()
         .background(Color.red)
         .foregroundColor(.white)
         .cornerRadius(10)
     }

     var backButton: some View {
         Button("Retour") {
             self.presentationMode.wrappedValue.dismiss()
         }
         .padding()
         .background(Color.gray)
         .foregroundColor(.white)
         .cornerRadius(10)
     }

    private func answerSelected(index: Int) {
        // Vérifier si la réponse est correcte
        if quizModel.questions[currentQuestionIndex].answer.rawValue == index + 1 {
            score += 1
        }
        
        // Passer à la question suivante ou afficher le score
        if currentQuestionIndex < quizModel.questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showScore = true
        }
    }
}

struct QCMView_Previews: PreviewProvider {
    @State static var isUserLoggedInPreview: Bool = false
    static var previews: some View {
        QCMView(isUserLoggedIn: $isUserLoggedInPreview)
    }
}
