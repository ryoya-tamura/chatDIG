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
    let isUserMessage: Bool
}

struct ContentView: View {
    
    @State var answerNumber = 0
    @State private var inputText = ""
    @State private var chatHistory: [Message] = []
    
    let openAI = OpenAISwift(authToken: "")
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                if answerNumber == 0 {
                    Text("ChatDIGへようこそ！！")
                        .frame(height: 100)
                        .font(.title)
                        .padding(.top,200)
                    
                    Text("-経験から強みを見つけてみよう-")
                    
                    Spacer()
                    Button("あなたの強みを見つける", action: {
                        answerNumber = answerNumber + 1
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: 50.0)
                    .font(.headline)
                    .background(Color(hue: 0.115, saturation: 0.852, brightness: 0.883))
                    .foregroundColor(Color.white)
                    .bold()
                    .padding(.bottom,200)
                } else if answerNumber == 1 {
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
                                        Image("cymbal") // アイコンの表示
                                            .resizable()
                                            .renderingMode(.original)
                                            .frame(width: 40, height: 40) // アイコンのサイズ
                                            .padding(.trailing, 8) // アイコンとメッセージの間の余白
                                        
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
                    
                    Button("分からない", action: {
                        
                    })
                    Button("あなたの強みとは...", action: {
                        answerNumber = answerNumber + 1
                    })
                    
                } else {
                    Text("あなたの強みは...")
                        .padding()
                    Text("分析結果")//関数を代入
                        .padding()
                    
                    Button("異なる経験から分析してみる", action: {
                        answerNumber = answerNumber - 2
                    })
                    
                }
                
            }
            .padding()

        }
    }
    
    func sendMessage() {//メッセージがsendされたら
        if inputText.isEmpty { return }
        
        chatHistory.append(Message(text: inputText, isUserMessage: true))

        print("###sendMessage###")
        Task{
            do {
                var chat: [ChatMessage] = [
                    ChatMessage(role: .system, content: "あなたは学生の就職活動を支援するエキスパートです。"),
                ]
//
                chat.append(ChatMessage(role: .user, content: inputText))
                
                // gpt-4が使えない。正確にはOpenAISwiftを介してだと使えない。
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
               
                if let choices = result.choices, let firstChoice = choices.first {
                    print("#################################")
                    var answer = firstChoice.message.content
                    print(answer)
                    chatHistory.append(Message(text: answer, isUserMessage: false))
                    self.inputText = ""
                    print("#################################")
                }
                

            } catch {
                // ...
                print("##error##")
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 
 
 print(chatHistory[1])
 
 let prompt = "##指示##¥n
 あなたは新卒採用人事のプロフェッショナルです。¥n
 以下の文章から、この#文章を書いた人の強みを#回答のフォーマットで3つ以上教えてください。¥n
 ##文章## -サッカーを頑張った。¥n
 ¥n
 ##回答##¥n
 強み:分析力¥n
 理由:彼はチームの士気低下の課題を見抜き、競争意識の低下を問題として認識しました。ゆえに、チームを分析して原因を推測し、解決策を見つけるための能力を持っています。¥n
 "
 
 chat.append(ChatMessage(role: .user, content: prompt))
 
 
 //message.contentに渡す
 //prompt
 ##指示##
 あなたは新卒採用人事のプロフェッショナルです。
 以下の文章から、この#文章を書いた人の強みを#回答のフォーマットで3つ以上教えてください。
 ##文章## -サッカーを頑張った。
 
 print(chatHistory)
 
 ##回答##
 強み:分析力
 理由:彼はチームの士気低下の課題を見抜き、競争意識の低下を問題として認識しました。ゆえに、チームを分析して原因を推測し、解決策を見つけるための能力を持っています。
 
 */







