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
                Text("CHUCK CHECKER")
                    .font(.system(size: 26, weight: .black, design: .default))
                    .padding(30)
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(mainColor).frame(width: 300, height: 300)
                            .softOuterShadow()
                        Image(chuckViewModel.className)
                    }.padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(mainColor).frame(width: 300, height: 100)
                            .softOuterShadow()
                        Text(String(format: "%.f", self.chuckViewModel.confidence) + "%")
                            .font(.system(size: 50, weight: .black, design: .default))
                    }.padding()
                }
                HStack {
                    Button(action: {self.chuckViewModel.mlSoundManager.start()}) {
                        Text("Start")
                            .font(.system(size: 22, weight: .black, design: .default))
                            .fontWeight(.bold)
                    }
                        .softButtonStyle(RoundedRectangle(cornerRadius: cornerRadius))
                        .padding(30)
                    Button(action: {self.chuckViewModel.mlSoundManager.stop()}) {
                        Text("Stop")
                            .font(.system(size: 22, weight: .black, design: .default))
                            .fontWeight(.bold)
                    }
                        .softButtonStyle(RoundedRectangle(cornerRadius: cornerRadius))
                        .padding(30)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .dark)
    }
}
