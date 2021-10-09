//
//  ChuckViewModel.swift
//  SPAJAM2021-yapparifuji
//
//  Created by Rei Nakaoka on 2021/10/09.
//

import SwiftUI
import Combine
import AVKit
import SoundAnalysis

class ChuckViewModel: ObservableObject {
    @Published var className: String = "noise"
    @Published var confidence = 0.0
    @Published var chuckConf = 0.0
    @Published var waterConf = 0.0
    @Published var noiseConf = 0.0
    private let notificationModel = NotificationModel()
    var classList: [String] = []
    let mlSoundManager = MLSoundManager()

    init() {
        mlSoundManager.resultsObserver.delegate = self
    }

    func classListReset() {
        for _ in 0..<20 {

        }
    }
    
    func notification() {
        notificationModel.makeNotification(genre: "チャック", item: "空いてますよ")
    }
}

extension ChuckViewModel: ClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double, classifications: [SNClassification]) {
        DispatchQueue.main.async { [self] in
            self.className = identifier
            self.confidence = confidence
            if classifications[0].identifier == "chack" {
                self.chuckConf = classifications[0].confidence*100
            } else if classifications[0].identifier == "water" {
                self.waterConf = classifications[0].confidence*100
            } else if classifications[0].identifier == "noise" {
                self.noiseConf = classifications[0].confidence*100
            }

            if classifications[1].identifier == "chack" {
                self.chuckConf = classifications[1].confidence*100
            } else if classifications[1].identifier == "water" {
                self.waterConf = classifications[1].confidence*100
            } else if classifications[1].identifier == "noise" {
                self.noiseConf = classifications[1].confidence*100
            }

            if classifications[2].identifier == "chack" {
                self.chuckConf = classifications[2].confidence*100
            } else if classifications[2].identifier == "water" {
                self.waterConf = classifications[2].confidence*100
            } else if classifications[2].identifier == "noise" {
                self.noiseConf = classifications[2].confidence*100
            }
            print(self.className)
        }
    }
}
