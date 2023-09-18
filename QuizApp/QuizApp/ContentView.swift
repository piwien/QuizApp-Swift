//
//  ContentView.swift
//  QuizApp
//
//  Created by Berkay Yaşar on 17.08.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager = QuizManager()
    
    @State var selection = 0
    @State var showStart = true
    @State var showResults = false
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(manager.questions.indices, id: \.self) { index in
                VStack {
                    Spacer()
                    QuestionView(question: $manager.questions[index])
                    Spacer()
                    if let lastQuestion = manager.questions.last,
                       lastQuestion.id == manager.questions[index].id {
                        Button{
                            manager.gradeQuiz()
                            showResults = true
                            manager.resetQuiz()
                            selection = 0
                           // print(manager.canSubmitQuiz())
                        } label: {
                            Text("Submit")
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color("AppColor"))
                                        .frame(width: 340)
                                )
                        }
                        .buttonStyle(.plain)
                        .disabled(!manager.canSubmitQuiz())
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // sayfa geçişi yaparken altta sayfa sayısı kadar nokta gösteriyor. Karanlık modda görebilirsin indexdisplay kısmını silip
        .fullScreenCover(isPresented: $showStart) {
            StartView()
        }
        .fullScreenCover(isPresented: $showResults) {
            ResultsView(result: manager.quizResult)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
