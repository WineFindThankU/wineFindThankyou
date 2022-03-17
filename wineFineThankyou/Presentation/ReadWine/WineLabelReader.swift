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

class WineLabelReader {
    class func doStartToOCR(_ image: UIImage, ocrDone: (([WineAtServer]) -> Void)?) {
        let koreanOptions = KoreanTextRecognizerOptions()
        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = getImageOrientation(UIDevice.current.orientation, cameraPosition: .back)
        koreanTextRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                ocrDone?([])
                return
            }
            
            AFHandler.searchWine(byKeyword: parsingReadText(result.text)) {
                ocrDone?($0)
            }
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
    
    class func parsingReadText(_ txt: String?) -> String {
        guard let parsingArr = txt?.components(separatedBy: "\n"),
              !parsingArr.isEmpty
        else { return "" }
        
        return parsingArr.first {
            $0.contains("제품명")
        }?.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: ":").last ?? ""
        
    }
}

