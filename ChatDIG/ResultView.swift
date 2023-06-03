//
//  ResultView.swift
//  ChatDIG
//
//  Created by misaki on 2023/06/02.
//

import SwiftUI

struct ResultView: View {
    
    var body: some View {
        ZStack{
            VStack{
                Text("あなたの強みは...")
                    .padding()
                Text("分析結果")//関数を代入
                    .padding()
                
                
//                Text(answer)//分析結果を表示
//                    .padding()
            }
        }
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
