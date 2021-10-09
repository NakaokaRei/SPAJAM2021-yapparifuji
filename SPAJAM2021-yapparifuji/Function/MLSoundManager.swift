//
//  MLSoundManager.swift
//  SPAJAM2021-yapparifuji
//
//  Created by Rei Nakaoka on 2021/10/09.
//

import AVKit
import SoundAnalysis

protocol ClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double)
}

class MLSoundManager {
    private let audioEngine = AVAudioEngine()
    private var soundClassifier = spajam_cml()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    var resultsObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "naist.yappari.AnalysisQueue")

    init() {
        startAudioEngine()
        setUpAnalyzer()
        startAnalyze()
    }

    func start() {
        do {
            try audioEngine.start()
        } catch( _) {
            print("error in starting the Audio Engin")
        }
    }

    func stop() {
        do {
            try audioEngine.stop()
        } catch( _) {
            print("error in starting the Audio Engin")
        }
    }

    private func startAudioEngine() {
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        do {
            try audioEngine.start()
        } catch( _) {
            print("error in starting the Audio Engin")
        }
    }

    private func setUpAnalyzer() {
        //分析するものはマイクの音声(ストリーミング)
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)

        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try analyzer.add(request, withObserver: resultsObserver)
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
    }

    private func startAnalyze() {
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 8000, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
    }
}

class ResultsObserver: NSObject, SNResultsObserving {
    var delegate: ClassifierDelegate?

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }

        let confidence = classification.confidence*100

        delegate?.displayPredictionResult(identifier: classification.identifier, confidence: confidence)
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}

