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
    var body: some View {
        Text(chuckViewModel.className)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
