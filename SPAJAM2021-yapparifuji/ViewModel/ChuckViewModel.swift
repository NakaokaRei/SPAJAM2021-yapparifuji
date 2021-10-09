//
//  ChuckViewModel.swift
//  SPAJAM2021-yapparifuji
//
//  Created by Rei Nakaoka on 2021/10/09.
//

import SwiftUI
import Combine

class ChuckViewModel: ObservableObject {
    @Published var className: String = "noise"
    @Published var confidence = 0
    private let notificationModel = NotificationModel()
    let mlSoundManager = MLSoundManager()

    init() {
        mlSoundManager.resultsObserver.delegate = self
    }
    
    func notification() {
        notificationModel.makeNotification(genre: "チャック", item: "空いてますよ")
    }
}

extension ChuckViewModel: ClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double) {
        DispatchQueue.main.async {
            self.className = identifier
            self.confidence = Int(confidence)
        }
    }
}
