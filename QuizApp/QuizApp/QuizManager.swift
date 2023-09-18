//
//  QuizManager.swift
//  QuizApp
//
//  Created by Berkay Yaşar on 25.08.2023.
//

import Foundation
import Supabase

class QuizManager: ObservableObject {
    
    @Published var questions = [Question]()
    @Published var quizResult = QuizResult(grade: "100%", correct: 0, total: 0)
    
   // @Published var mockQuestions = [
    //     Question(title: "When was the iPhone first released?", answer: "A", options: ["A","B","C","D"]),
    //    Question(title: "When was t", answer: "A", options: ["A","B","C","D"]),
    //    Question(title: "iPhone first released?", answer: "A", options: ["A","B","C","D"]),
    //   Question(title: "first released?", answer: "A", options: ["A","B","C","D"])
    // ]
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://gczkeoebheishjgentwq.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdjemtlb2ViaGVpc2hqZ2VudHdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTI5NjI0MjYsImV4cCI6MjAwODUzODQyNn0.QuflQBpOfAm20JjzM3uUx7yNqipGMpUA7D04BJhm0IY")
    
    init() {
        Task {
            do {
                let response = try await client.database.from("quiz").select().execute()
                let data = response.underlyingResponse.data
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.questions = try decoder.decode([Question].self, from: data)
                await MainActor.run {
                    self.questions = questions
                }
            }
            print("error fetching questions")
        }
    }
    
    func canSubmitQuiz() -> Bool {
        return questions.filter({ $0.selection == nil }).isEmpty
    }
    
    func gradeQuiz() {
        var correct: CGFloat = 0
        for question in questions {
            if question.answer == question.selection {
                correct += 1
            }
        }
        self.quizResult = QuizResult(grade: "\((correct/CGFloat(questions.count)) * 100)%", correct: Int(correct), total: questions.count)
    }
    
    func resetQuiz() {
        self.questions = questions.map({ Question(id: $0.id, createdAt: $0.createdAt, title: $0.title, answer: $0.answer, options: $0.options, selection: nil)})
    }
}

struct QuizResult {
    let grade: String
    let correct: Int
    let total: Int
}
