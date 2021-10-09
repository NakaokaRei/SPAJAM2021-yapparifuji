//
//  ContentView.swift
//  SPAJAM2021-yapparifuji
//
//  Created by Rei Nakaoka on 2021/10/08.
//

import SwiftUI
import Neumorphic

struct ContentView: View {
    @ObservedObject var chuckViewModel = ChuckViewModel()
    let cornerRadius : CGFloat = 15
    let mainColor = Color.Neumorphic.main
    let secondaryColor = Color.Neumorphic.secondary

    var body: some View {
        ZStack {
            mainColor.edgesIgnoringSafeArea(.all)
            VStack {
                Text(chuckViewModel.className)
                    .padding()
                Text("CHACK CHECKER")
                    .font(.system(size: 26, weight: .black, design: .default))
                    .padding()
                RoundedRectangle(cornerRadius: cornerRadius).fill(mainColor).frame(width: 300, height: 300)
                    .softOuterShadow()
                Button(action: {}) {
                    Text("Soft Button")
                        .font(.system(size: 22, weight: .black, design: .default))
                        .fontWeight(.bold)
                }
                    .softButtonStyle(RoundedRectangle(cornerRadius: cornerRadius))
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .dark)
    }
}
