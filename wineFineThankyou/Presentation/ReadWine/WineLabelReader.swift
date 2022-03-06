//
//  WineLabelReader.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/12.
//

import Foundation
import UIKit
import MLKitTextRecognitionKorean
import MLKitVision
import AVFoundation

class ReadWineInfo {
    var name: String?
    var from: String?
    var vintage: String?
    var date: Date?
    init(name: String?, from: String?, vintage: String?) {
        self.name = name
        self.from = from
        self.vintage = vintage
    }
    func isEmpty() -> Bool {
        guard let name = self.name, !name.isEmpty,
              let from = self.from, !from.isEmpty,
              let vintage = self.vintage, !vintage.isEmpty,
              nil != self.date else { return false }
        return true
    }
}

class WineLabelReader {
    class func doStartToOCR(_ image: UIImage, ocrDone: ((ReadWineInfo?) -> Void)?) {
        let koreanOptions = KoreanTextRecognizerOptions()
        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = getImageOrientation(UIDevice.current.orientation, cameraPosition: .back)
        koreanTextRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                ocrDone?(nil)
                return
            }
            
            guard let name = parsingReadText(result.text)?.name else {
                ocrDone?(nil)
                return
            }
            AFHandler.getWineInfo(name.trimmingCharacters(in: .whitespaces), done: {
                ocrDone?($0)
            })
        }
    }
    
    class func getImageOrientation(_ deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            return .leftMirrored
        }
    }
    
    class func parsingReadText(_ txt: String?) -> ReadWineInfo? {
        guard let parsingArr = txt?.components(separatedBy: "\n"),
              !parsingArr.isEmpty
        else { return nil }
        
        //제품명
        let from = parsingArr.first {
            $0.contains("원산지")
        }?.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: ":").last
        
        let name = parsingArr.first {
            $0.contains("제품명")
        }?.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: ":").last
        
        let vintage = parsingArr.first {
            $0.contains("병입연월일")
        }?.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: ":").last

        if let nnVintage = vintage, nnVintage.contains(where: {$0.isNumber}) {
            return ReadWineInfo(name: name, from: from, vintage: nnVintage)
        } else {
            return ReadWineInfo(name: name, from: from, vintage: nil)
        }
    }
}

