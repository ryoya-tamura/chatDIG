//
//  ContentView.swift
//  ChatDIG
//
//  Created by 相川佑也 on 2023/05/29.
//

// sendMessageされたら質問と回答をペアでchat_logに保存する
// 質問の数だけ繰り返す
//最後の質問まで終わったら、chat_logを整形する
//整形したやつをchatgptに投げる

import SwiftUI
import OpenAISwift

struct Message: Hashable {
    let text: String
    let isUserMessage: Bool
}


struct ContentView: View {
    
    @State var answerNumber = 0
    @State private var inputText = ""
    @State private var chatHistory: [Message] = []
    
    let openAI = OpenAISwift(authToken: "")

    
    
    var body: some View {
        NavigationView{
            VStack {
                if answerNumber == 0{
                    Text("ChatDIGへようこそ！！")
                        .frame(height: 100)
                        .font(.title)
                        .padding(.top,200)
                    
                    Text("-経験から強みを見つけてみよう-")
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
                    //                Text("会話画面")
                    //                    .padding()
                    //                Button("あなたの強みとは...", action:{
                    //                    answerNumber = answerNumber + 1
                    //                })
                                    Text("質問に答えてください。")
                                        .font(.title)
                                        .foregroundColor(Color.orange)
                    ScrollViewReader { scrollView in
                        ScrollView {
                            ForEach(chatHistory, id: \.self) { message in
                                HStack {
                                    if message.isUserMessage {
                                        Spacer()
                                        Text(message.text)
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                    } else {
                                        Text(message.text)
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .background(Color.green)
                                            .cornerRadius(8)
                                        Spacer()
                                    }
                                }
                                .padding(4)
                                .id(message)
                            }
                        }
                        .onChange(of: chatHistory) { _ in
                            withAnimation {
                                scrollView.scrollTo(chatHistory.last, anchor: .bottom)
                            }
                        }
                    }
                    HStack {
                        TextField("Type your message here...", text: $inputText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        Button(action: sendMessage) {
                            Text("Send")
                        }
                        .padding(.trailing)
                    }
                    
                    //.navigationBarTitle("質問に答えてください")
                    .padding()
                    Button("あなたの強みとは...", action:{
                        answerNumber = answerNumber + 1
                    })
                    
                }else {
                    Text("あなたの強みは...")
                        .padding()
                    Text("分析結果ずら")//関数を代入
                        .padding()
                    Button("異なる経験から分析してみる", action:{
                        answerNumber = answerNumber - 2
                    })
                    
                }
                
                
            }
            .padding()
        }
    }
   
    
    func sendMessage() {//メッセージがsendされたら
        print("###sendMessage###")
        Task{
            do {
                let chat: [ChatMessage] = [
                    ChatMessage(role: .system, content: "あなたは学生の就職活動を支援するエキスパートです。"),
                    ChatMessage(role: .user, content: "日本で起きた2020年の大きなニュースを教えてください")
                ]

                let result = try await openAI.sendChat(
                    with: chat,
                    model: .chat(.chatgpt),         // optional `OpenAIModelType`
                    user: nil,                      // optional `String?`
                    temperature: 1,                 // optional `Double?`
                    topProbabilityMass: 1,          // optional `Double?`
                    choices: 1,                     // optional `Int?`
                    stop: nil,                      // optional `[String]?`
                    maxTokens: nil,                 // optional `Int?`
                    presencePenalty: nil,           // optional `Double?`
                    frequencyPenalty: nil,          // optional `Double?`
                    logitBias: nil                 // optional `[Int: Double]?` (see inline documentation)
                )
                // use result
                print("##success##")
                print(result)
                print("#################################3")

            } catch {
                // ...
                print("##error##")
                print(error)
            }
        }
        
//        print("#########sendCompletion###########")
//        openAI.sendCompletion(with: "Hello how are you") { result in
//            switch result {
//            case .success(let success):
//                if let choices = success.choices, let firstChoice = choices.first {
//                    print(firstChoice.text ?? "")
//                } else {
//                    print("##########No text was generated.##########")
//                }
//            case .failure(let failure):
//                print("#######errrr##########")
//                print(failure.localizedDescription)
//            }
//        }
    }
        
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
