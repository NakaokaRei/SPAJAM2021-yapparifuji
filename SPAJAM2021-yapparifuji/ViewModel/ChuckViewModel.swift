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
    @Published var chuckConf = 0.0
    @Published var waterConf = 0.0
    @Published var noiseConf = 0.0
    private let notificationModel = NotificationModel()
    let mlSoundManager = MLSoundManager()
    var classificationList: [String] = [] //こんなところに

    init() {
        mlSoundManager.resultsObserver.delegate = self
        classificationListReset()
    }

    func classificationListReset() {
        self.classificationList = []
        for _ in 0..<20 {
            self.classificationList.append("noise")
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
            
            checkClassName(listNum: 0, classifications: classifications)
            checkClassName(listNum: 1, classifications: classifications)
            checkClassName(listNum: 2, classifications: classifications)
            
           
        }
    }
    
    func checkClassName(listNum: Int,classifications:[SNClassification] ) {
        if classifications[listNum].identifier == "chack" {
            self.chuckConf = classifications[listNum].confidence*100
            operateList(confidence: classifications[listNum].confidence, name: classifications[listNum].identifier)
        } else if classifications[listNum].identifier == "water" {
            self.waterConf = classifications[listNum].confidence*100
            operateList(confidence: classifications[listNum].confidence, name: classifications[listNum].identifier)
        } else if classifications[listNum].identifier == "noise" {
            self.noiseConf = classifications[listNum].confidence*100
            operateList(confidence: classifications[listNum].confidence, name: classifications[listNum].identifier)
        }
    }
    
    func operateList(confidence: Double, name: String){
        var validNoise: Int = 0
        var validWater: Int = 0
        var validChuck: Int = 0
        //100%の時だけバッファリング，リストの長さが20超えたら最初消してバッファリング
        if confidence*100 > 90 && self.classificationList.count <= 20{
            self.classificationList.append(name)
        }else if confidence*100 > 90{
            self.classificationList.removeFirst()
            self.classificationList.append(name)
        }
        print(confidence*100, self.classificationList)
        
        // noise -> water -> chuckの順になった時に通知を発行する (listの数が20ないと判定できない)
        if (classificationList.count >= 20){
            
            validNoise = classificationList[1...10].filter({$0 == "noise"}).count
            validWater = classificationList[6...11].filter({$0 == "water"}).count
            validChuck = classificationList[9...19].filter({$0 == "chack"}).count
            
            print(validNoise, validWater, validChuck)
        }
        
        //ここでめちゃくちゃ良しなに判定してほしい
        if (validNoise > 4 && validWater > 5 && validChuck == 0) {
            mlSoundManager.stop()
            self.notification()
            self.classificationListReset()
        } else if (validWater > 3 && validChuck > 0) {
            notificationModel.makeNotification(genre: "チャック", item: "を閉めました！！！！！！！！！！！！！！！！")
            self.classificationListReset()
        }
        
    }
}
