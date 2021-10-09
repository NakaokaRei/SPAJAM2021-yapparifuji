//
//  ChuckViewModel.swift
//  SPAJAM2021-yapparifuji
//
//  Created by Rei Nakaoka on 2021/10/09.
//

import SwiftUI
import Combine

class ChuckViewModel: ObservableObject {
    @Published var className: String = "hello"
    private let mlSoundManager = MLSoundManager()

    init() {
        mlSoundManager.resultsObserver.delegate = self
    }
}

extension ChuckViewModel: ClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double) {
        DispatchQueue.main.async {
            self.className = ("Recognition: \(identifier)\nConfidence \(confidence)")
        }
    }
}
