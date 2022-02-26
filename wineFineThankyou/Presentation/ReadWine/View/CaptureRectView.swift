//
//  CaptureRectView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/26.
//

import Foundation
import UIKit

class CaptureRectView: UIView {
    var transRect: CGRect = CGRect.zero
    var bgColor: UIColor = UIColor.clear

    convenience init(frame: CGRect, bgColor: UIColor, transRect: CGRect) {
        self.init(frame: frame)
        self.isOpaque = false

        self.bgColor = bgColor
        self.transRect = transRect
    }
    
    override func draw(_ rect: CGRect) {
        // 배경 채우기
        bgColor.setFill()
        UIRectFill(rect)
        UIColor.clear.setFill()
        UIRectFill(rect.intersection(transRect))
        
        let path = UIBezierPath(roundedRect: transRect, cornerRadius: 8)
        UIColor(rgb: 0x7B61FF).set()
        path.lineWidth = 2
        path.stroke()
    }
}
