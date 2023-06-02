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
    
    @State var answerNumber = 0
    @State private var inputText = ""
    @State private var isUserResponse = true;
    @State private var chatHistory: [Message] = [Message(text: "あなたが人生で一番一生懸命頑張ったことはなんですか？", isUserMessage: 2)]
    @State private var questionNumber = 0
    @State private var hintList: Array<String> = [
        "ヒント1",
        "ヒント2",
        "ヒント3",
        "ヒント4",
        "ヒント5",
        "ヒント6",
        "ヒント7"
    ]
    @State var questionList: Array<String> = [
        "あなたが人生で一番一生懸命頑張ったことはなんですか？" ,
        "その具体的な経験について教えてください。",
        "どのように楽しかったのですか？理由も含めて教えてください。",
        "どのように頑張ったのですか？理由も含めて教えてください。",
        "どのように苦しかった/辛かったのですか？理由も含めて教えてください。",
        "その辛かったこと・苦しかったことをどのようにして乗り越えましたか？",
        "これで最後に質問です。あなたが一生懸命頑張った経験から、得られた成果について教えてください。" ]
    
    @State var prompt = ""
    @State var userAnswer: Array<String> = [
        "A","B","C","D","E","F","G"
        ]
    @State var answer: String = "お待ちください"
    
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
                                    if message.isUserMessage == 1 {
                                        Spacer()
                                        Text(message.text)
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(8)

                                    } else if message.isUserMessage == 2{
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
                                    } else if message.isUserMessage == 3{
                                        Text(message.text)
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .background(Color.yellow)
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
                    
                    Button(action: displayHint) {
                        Text("ヒント見る")
                    }
                    Button("あなたの強みとは...", action: {
                        answerNumber = answerNumber + 1
                        AskGPT()
                    })
                    
                } else {
//                ZStack{
//                        Image("dart")
                    
                        Text("あなたの強みは...")
                            .padding()
                        Text("分析結果")//関数を代入
                            .padding()
                        Text(answer)//分析結果を表示
                            .padding()
                        
                        Button(action: {
                            answerNumber = answerNumber - 2
                        }) {
                            Text("異なる経験から分析してみる")
                                .font(.system(size: 22, weight: .black, design: .default))
                                .frame(width: 320, height: 64)
                                .foregroundColor(Color(.black))
                                .background(Color(.green))
                                .cornerRadius(12)
                        }
//                    }
                }
                
            }
            .padding()

        }
    }
    
    func AskGPT(){
        Task{
            do {
                var chat: [ChatMessage] = [
                    ChatMessage(role: .system, content: "あなたは学生の就職活動を支援するエキスパートです。"),
                ]
                //if userAnswer[0]&&userAnswer[1]&&userAnswer[2]&&userAnswer[3]&&userAnswer[4] {
                let prompt = """
                ##指示##
                あなたは新卒採用人事のプロフェッショナルです。
                以下の文章から、この#文章を書いた人の強みを分析して#回答例を参考に#形式のフォーマットで1つ教えてください。
                ##文章##
                -\(userAnswer[0])
                -\(userAnswer[1])
                -\(userAnswer[2])
                -\(userAnswer[3])
                -\(userAnswer[4])
                -\(userAnswer[5])
                -\(userAnswer[6])
                ##回答例##
                強み:分析力
                理由:彼はチームの士気低下の課題を見抜き、競争意識の低下を問題として認識しました。ゆえに、チームを分析して原因を推測し、解決策を見つけるための能力を持っています。
                強み: 問題解決能力
                理由:彼はチームの士気低下という問題に直面しましたが、それを分析し、競争意識の低下を原因と特定しました。その後、解決策としてMVP発表活動を導入し、チーム内の競争意識を高めました。彼の問題解決能力によって、具体的な目標に向かって効果的な対策を講じることができました。
                
                ##形式##
                強み：
                理由：
                """
                print(prompt)
                
                //}
                chat.append(ChatMessage(role: .user, content: prompt))
                
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
                    answer = firstChoice.message.content
                    print(answer)
//                    chatHistory.append(Message(text: answer, isUserMessage: false))
                    print("#################################")
                }
                

            } catch {
                // ...
                print("##error##")
                print(error)
            }
        }
    }
    
    func sendMessage() {//メッセージがsendされたら
        if inputText.isEmpty { return }
        
        chatHistory.append(Message(text: inputText, isUserMessage: 1))
        userAnswer[questionNumber] = inputText
        //userAnswer.append(inputText)
        questionNumber+=1
        switch questionNumber {
        case 1:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        case 2:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        case 3:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        case 4:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        case 5:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        case 6:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        case 7:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
        default:
            print("これ以上質問はありません")
        }
        self.inputText = ""
        

        print("###sendMessage###")
        
    }
    
    func displayHint(){
        chatHistory.append(Message(text: hintList[questionNumber], isUserMessage: 3))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 
 debag
 全部打ち終わってヒント押すとエラーでる
 
 
 //message.contentに渡す
 //prompt
 ##指示##
 あなたは新卒採用人事のプロフェッショナルです。
 以下の文章から、この#文章を書いた人の強みを#回答のフォーマットで3つ以上教えてください。
 ##文章##
 
 ##回答##
 強み:分析力
 理由:彼はチームの士気低下の課題を見抜き、競争意識の低下を問題として認識しました。ゆえに、チームを分析して原因を推測し、解決策を見つけるための能力を持っています。
 
 */







