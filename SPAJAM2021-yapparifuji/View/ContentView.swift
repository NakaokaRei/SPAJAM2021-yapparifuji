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
                Text("CHUCK CHECK")
                    .font(.system(size: 35, weight: .black, design: .default))
                    .padding()
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(mainColor).frame(width: 300, height: 300)
                            .softOuterShadow()
                        Image(chuckViewModel.className)
                    }.padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(mainColor).frame(width: 300, height: 180)
                            .softOuterShadow()
                        VStack {
                            Text("CHUCK　" + String(format: "%.f", chuckViewModel.chuckConf) + "%")
                                .font(.system(size: 35, weight: .black, design: .default))
                            Text("WATER　" + String(format: "%.f", chuckViewModel.waterConf) + "%")
                                .font(.system(size: 35, weight: .black, design: .default))
                            Text("NOISE　" + String(format: "%.f", chuckViewModel.noiseConf) + "%")
                                .font(.system(size: 35, weight: .black, design: .default))
                        }
                    }.padding()
                }
                HStack {
                    Button(action: {self.chuckViewModel.mlSoundManager.start()}) {
                        Text("Start")
                            .font(.system(size: 22, weight: .black, design: .default))
                            .fontWeight(.bold)
                    }
                        .softButtonStyle(RoundedRectangle(cornerRadius: cornerRadius))
                        .padding()
                    Button(action: {
                        self.chuckViewModel.mlSoundManager.stop()
                        self.chuckViewModel.notification()
                    }) {
                        Text("Stop")
                            .font(.system(size: 22, weight: .black, design: .default))
                            .fontWeight(.bold)
                    }
                        .softButtonStyle(RoundedRectangle(cornerRadius: cornerRadius))
                    .padding()
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
