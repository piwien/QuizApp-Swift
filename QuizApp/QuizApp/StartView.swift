//
//  StartView.swift
//  QuizApp
//
//  Created by Berkay Yaşar on 25.08.2023.
//

import SwiftUI

struct StartView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 25){
            Text("Quiz App")
                .font(.system(size: 64))
            Text("Are you ready to start the quiz?!?").font(.system(size: 24))
            
            Button {
                dismiss()
            } label: {
                Text("Start")
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color("AppColor"))
                            .frame(width: 340)
                    )
            }
            .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.bottom, 50)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
