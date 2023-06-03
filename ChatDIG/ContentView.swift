//
//  ContentView.swift
//  ChatDIG
//
//  Created by 相川佑也 on 2023/05/29.
//

import SwiftUI
import OpenAISwift

struct Message: Hashable {
    let text: String
    let isUserMessage: Int
}

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack {
                
                Text("ChatDIGへようこそ！！")
                    .frame(height: 100)
                    .font(.title)
                    .padding(.top,200)
                
                Text("-経験から強みを見つけてみよう-")
                
                Spacer()
                NavigationLink(destination: ConversationView()){
                    Text("あなたの強みを見つけよう")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50.0)
                        .font(.headline)
                        .background(Color(hue: 0.115, saturation: 0.852, brightness: 0.883))
                        .foregroundColor(Color.white)
                        .bold()
                        .padding(.bottom,200)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






