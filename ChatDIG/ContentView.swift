//
//  ContentView.swift
//  ChatDIG
//
//  Created by 相川佑也 on 2023/05/29.
//

import SwiftUI
import OpenAISwift
import UIKit

struct Message: Hashable {
    let text: String
    let isUserMessage: Int
}

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.color = UIColor.green
        uiView.startAnimating()
    }
}



struct BarProgressStyle: ProgressViewStyle {
 
    var height: Double = 30.0
    var width: Double = 508.0
    var labelFontStyle: Font = .body
 
    func makeBody(configuration: Configuration) -> some View {
 
        let progress = configuration.fractionCompleted ?? 0.0
 
        GeometryReader { geometry in
 
            VStack() {
 
                configuration.label
                    .font(labelFontStyle)
 
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(UIColor(red: 169/255, green: 117/255, blue: 80/255, alpha: 1)))
                    .frame(height: height)
                    .frame(width: width)
                    .overlay(alignment: .leading) {
                        //RoundedRectangle(cornerRadius: 10.0)
                        Rectangle()
                            .fill(Color(uiColor: .systemGray5))
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                            .frame(width: width * progress)
                            .overlay(alignment: .leading) {
                                if let currentValueLabel = configuration.currentValueLabel {
 
                                    currentValueLabel
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
 
            }
 
        }
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct ContentView: View {
    
    @State var answerNumber = 0
    @State private var inputText = ""
    @State private var isUserResponse = true;
    @State private var chatHistory: [Message] = [Message(text: "あなたが人生で一番一生懸命頑張ったことはなんですか？", isUserMessage: 2)]
    @State private var questionNumber = 0
    @State private var chat: [ChatMessage] = []
    @State private var hintList: Array<String> = [
        "ヒント1",
        "ヒント2",
        "ヒント3",
        "ヒント4",
        "ヒント5",
        "ヒント6",
        "ヒント7",
        "質問は以上です。結果出力画面に進んでください。"
    ]
    
    @State var questionList: Array<String> = [
        "あなたが人生で一番一生懸命頑張ったことはなんですか？" ,
        "その具体的な経験について教えてください。",
        "どのように楽しかったのですか？理由も含めて教えてください。",
        "どのように頑張ったのですか？理由も含めて教えてください。",
        "どのように苦しかった/辛かったのですか？理由も含めて教えてください。",
        "その辛かったこと・苦しかったことをどのようにして乗り越えましたか？",
        "これで最後に質問です。あなたが一生懸命頑張った経験から、得られた成果について教えてください。",
        "お疲れ様でした。質問は以上です。結果出力の画面に進んでください。"]
    
    @State var prompt = ""
//    @State var userAnswer: Array<String> = [
//        "A","B","C","D","E","F","G"
//        ]
    @State var userAnswer: Array<String> = []
    @State var answer: String = "お待ちください"
    @State private var progress = 0.0
    
    @State var topLeft: CGFloat = 0
    @State var topRight: CGFloat = 0
    @State var bottomLeft: CGFloat = 0
    @State var bottomRight: CGFloat = 0
    
    let openAI = OpenAISwift(authToken: "")
    
    
    
    var body: some View {
        NavigationView {

                
                VStack {
                    
                    if answerNumber == 0 {
                        
                        ZStack{
                            Image("dart start") // 背景画像
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .edgesIgnoringSafeArea(.all)
                            VStack{
                                VStack(spacing:0){
                                    Text("ChatDIGとは？")
                                        .font(.title)
                                        .bold()
                                        .padding(.bottom,20)
                                    Text("ユーザの過去からの経験から強みを特定するAIチャットアプリです。従来の自己分析手法に変わる新しいアプローチで、客観的な視点でユーザの強みを明確にします。")
                                        
                                }
                                .frame(width: 350,height: 200)
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.top,100)
                                
                                
                                Text("君も潜ってみる？")
                                    .frame(width: 150,height: 35)
                                    .background(Color.white)
                                    .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
                                    .padding([.top, .leading],70)
                                
                                Spacer()
                                Button("あなたの強みを見つける", action: {
                                    answerNumber = answerNumber + 1
                                })
                                .font(.system(size: 22, weight: .black, design: .default))
                                .frame(width: 320, height: 64)
                                .foregroundColor(Color(.black))
                                .background(Color(UIColor(red: 225/255, green: 255/255, blue: 103/255, alpha: 1)))
                                .cornerRadius(12)
                                .padding(.bottom,200)
                                
                                /*
                                 //配列等初期化
                                 .onAppear{
                                 var userAnswer = Array (repeating : "XXX", count : 7)
                                 }
                                 */
                            }
                            
                            
                    }
                        .frame(width: 400, height: 200, alignment: .center)//frame ireru
                
                }else if answerNumber == 1 {
                    
                    ZStack() {
                                Image("dart chat view") // 背景画像
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    .edgesIgnoringSafeArea(.all)
                                    
                                VStack {
                                    //Spacer()
                                    //Text("")
                                    //.font()
                                    
                                    ZStack {
                                        Text("質問に答えてください。")
                                            .font(.title)
                                            .foregroundColor(Color(UIColor(red: 176/255, green: 242/255, blue: 238/255, alpha: 1)))
                                            //.border(Color.blue)
                                            //.frame(width: 400, height: 200, alignment: .top)
                                            .padding(.top, 30.0)
                                        
                                        HStack{
                                            Button(action: {
                                                displayHint()
                                                //progress += 0.2
                                            }){
                                                Text("ヒント")
                                                    .font(.system(size: 16, weight: .black, design: .default))
                                                    .frame(width: 120, height: 100)
                                                    .foregroundColor(Color(.black))
                                                    .background(Image("cloud"))
                                                    .cornerRadius(12)
                                            }
                                            //.frame(width: 100 , height: 30, alignment: .center)
                                            //.border(Color.black)
                                            .padding(.trailing, 250)
                                            
                                            /*
                                            Button( action: {
                                                //answerNumber = answerNumber + 1
                                                //progress += 0.2
                                                //AskGPT()
                                            }){
                                                Text("あなたの強みとは...")
                                                    .font(.system(size: 16, weight: .black, design: .default))
                                                    .frame(width: 180, height: 32)
                                                    .foregroundColor(Color(.black))
                                                    .background(Color(.white))
                                                    .cornerRadius(12)
                                            }
                                            //.frame(width: 200 , height: 30, alignment: .center)
                                            //.border(Color.blue)
                                            */
                                        }
                                        
                                    }
                                    
                                    HStack{
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
                                                                .cornerRadius(8, corners: [.topLeft, .bottomLeft, .bottomRight])
                                                            
                                                        } else if message.isUserMessage == 2 {
                                                            //user massage
                                                                    Image("Icon DIG mogra")
                                                                        .resizable()
                                                                        //.renderingMode(.original)
                                                                        .frame(width: 40, height: 40, alignment: .topLeading)
                                                                        //.padding(.left, 2)
                                                                    
                                                                Text(message.text)
                                                                    .padding(8)
                                                                    .foregroundColor(.white)
                                                                    .background(Color.green)
                                                                    .cornerRadius(8, corners: [.topRight, .bottomLeft, .bottomRight])
                                                                    Spacer()
                                                            
                                                        } else if message.isUserMessage == 3 {
                                                            //hint
                                                            Image("Icon DIG mogra")
                                                                .resizable()
                                                                //.renderingMode(.original)
                                                                .frame(width: 40, height: 40, alignment: .topLeading)
                                                                //.padding(.left, 2)
                                                            Text(message.text)
                                                                .padding(8)
                                                                .foregroundColor(.white)
                                                                .background(Color.yellow)
                                                                .cornerRadius(8, corners: [.topRight, .bottomLeft, .bottomRight])
                                                            Spacer()
                                                        }
                                                        
                                                    }
                                                    //.padding(.leading)
                                                    //.padding(.trailing, 50)
                                                    .id(message)
                                                }
                                            }
                                            .onChange(of: chatHistory) { _ in
                                                withAnimation {
                                                    scrollView.scrollTo(chatHistory.last, anchor: .bottom)
                                                }
                                            }
                                            
                                        }
                                        //.border(Color.blue)
                                        .padding(.leading)
                                                
                                            ProgressView(value: progress)
                                                .progressViewStyle(BarProgressStyle())
                                                .frame(width: 20 , height: 30, alignment: .leading)
                                                //.border(Color.blue)
                                                .rotationEffect(Angle(degrees: 90))
                                                .padding(.bottom, 579.0)//bar の位置
                                                .padding()
                                                //.border(Color.blue)
                                    }
                                    .frame(width: 400, height: 600, alignment: .center)
                                    //.border(Color.black)
                                    
                                    

                                    HStack {
                                        TextField("Type your message here...", text: $inputText) //, axis: .vertical
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.default)
                                            .padding(.horizontal)
                                        Button(action: {
                                            sendMessage()
                                        }){
                                            Image("push")
                                                .resizable()
                                                .frame(width: 40, height: 38)
                                        }
                                        .padding(.trailing)
                                    }
                                    //.border(Color.blue)

                                    /*
                                    Button("ヒント見る", action: {
                                        displayHint()
                                        //progress += 0.2
                                    })
                                     */
                                     Button( action: {
                                         answerNumber = answerNumber + 1
                                         //progress += 0.2
                                         AskGPT()
                                     }){
                                         Text("あなたの強みとは...")
                                             .font(.system(size: 16, weight: .black, design: .default))
                                             .frame(width: 180, height: 32)
                                             .foregroundColor(Color(.black))
                                             .background(Color(UIColor(red: 225/255, green: 255/255, blue: 103/255, alpha: 1)))
                                             .cornerRadius(12)
                                     }
                                    

                                    
                                }

                                
                            }
                            .frame(width: 400, height: 200, alignment: .center)
                        
                    
            } else {
                    ZStack(){
                        
                        Image("dart")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                        //多分上下が小さい画像を使ってる
                        
                        
                        VStack{
                            Text("あなたの強みは...")
                                .font(.title)
                                .frame(width: 400, height: 20, alignment: .top)
                            //.border(Color.black, width: 1)
                            .padding(.top, 60.0)

                            Text("")//関数を代入
                            //.frame(width: 400, height: 200, alignment: .center)
                            //.border(Color.black, width: 1)
                                .padding(.vertical, 20.0)
                            //Spacer()
                            
                            ZStack{
                                
                                // 四角形の描画
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color.white)               // 図形の塗りつぶしに使うViewを指定
                                    .frame(width:380, height: 300)  // フレームサイズ指定
                                
                                Text(answer)//分析結果を表示
                                .frame(width: 400, height: 200)
                                //.border(Color.black, width: 1)
                                //Spacer()
                                //.padding()
                                
                                //アンサー長文で帰ってくるとレイアウト崩れるね

                            }
                            .frame(width: 400, height: 200, alignment: .center)
                            Spacer()
                            
                            
                            Button(action: {
                                answerNumber -= 2
                                Initialize()
                            })
                            { Text("異なる経験から分析してみる")
                                    .font(.system(size: 22, weight: .black, design: .default))
                                    .frame(width: 320, height: 64)
                                    .foregroundColor(Color(.black))
                                    .background(Color(UIColor(red: 225/255, green: 255/255, blue: 103/255, alpha: 1)))
                                    .cornerRadius(12)
                            }
                            .frame(width: 400, height: 300, alignment: .center)
                            //.border(Color.black, width: 1)
                        }
                        //.padding()
                        if answer.hasSuffix("お待ちください"){//Suf後ろ Pre頭
                            Color.black.opacity(0.3)
                                .edgesIgnoringSafeArea(.all)
                            ActivityIndicator()
                                .frame(width: 400, height: 200, alignment: .top)
                            //.padding()
                            //test use
                            Button(action: {
                                answer.removeLast(7)
                                answer.append("緑のボタンから始めにお戻りください")
                            }) {
                                Text("キャンセル")
                                    .font(.system(size: 18, weight: .black, design: .default))
                                    .frame(width: 180, height: 64)
                                    .foregroundColor(Color(.black))
                                    .background(Color(.white))
                                    .cornerRadius(12)
                            }
                            .frame(width: 400, height: 200, alignment: .bottom)
                            
                        }
                        
                    }
                    .frame(width: 400, height: 200, alignment: .center)
                }
                
            }
            .padding()

        }
    }
    
    
    func Initialize(){
        chatHistory = [Message(text: "あなたが人生で一番一生懸命頑張ったことはなんですか？", isUserMessage: 2)]
        progress = 0.0
        answer = "お待ちください"
        userAnswer = []
        questionNumber = 0
    }

    
    func AskGPT(){
        Task{
            do {
                if userAnswer.count >= 7 {
                    prompt = """
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
                
                }
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
    
    func sendMessage() {
        if inputText.isEmpty { return }
        
        chatHistory.append(Message(text: inputText, isUserMessage: 1))
//        userAnswer[questionNumber] = inputText
        userAnswer.append(inputText)
        questionNumber+=1
        switch questionNumber {
        case 1:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        case 2:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        case 3:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        case 4:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        case 5:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        case 6:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        case 7:
            chatHistory.append(Message(text: questionList[questionNumber], isUserMessage: 2))
            progress += 0.143
        default:
            print("これ以上質問はありません")
        }
        self.inputText = ""
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
 
 多分appendじゃなくて指定したところを書き換える形にしたからだ
 questionnumberを初期化か何かすればいいはず
 -chigatta
 
 
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







