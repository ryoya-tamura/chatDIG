//
//  ContentView.swift
//  ChatDIG
//
//  Created by 相川佑也 on 2023/05/29.
//

import SwiftUI

struct ContentView: View {
    
    @State var answerNumber = 0
    
    var body: some View {
        VStack {
            if answerNumber == 0{
                Text("ChatDIGへようこそ！！")
                    .frame(height: 100)
                    .font(.title)
                    .padding(.top,200)
                
                Text("-経験から強みを見つけよう-")
                    //.padding()
                    Spacer()
                Button("あなたの強みを見つける", action:{
                    answerNumber = answerNumber + 1
                })
                .frame(maxWidth: .infinity)
                .frame(height: 50.0)
                .font(.headline)
                .background(Color(hue: 0.115, saturation: 0.852, brightness: 0.883))
                .foregroundColor(Color.white)
                .bold()
                .padding(.bottom,200)
                
                
            }else if answerNumber == 1{
                Text("会話画面")
                    .padding()
                Button("あなたの強みとは...", action:{
                    answerNumber = answerNumber + 1
                })
                
            }else {
                Text("あなたの強みは...")
                    .padding()
                Text("分析結果")//関数を代入
                    .padding()
                Button("異なる経験から分析してみる", action:{
                    answerNumber = answerNumber - 2
                })
                
            }
            
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

