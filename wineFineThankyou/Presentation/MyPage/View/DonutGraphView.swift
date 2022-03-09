//
//  DonutGraphView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/19.
//

import Foundation
import UIKit

enum GraphType{
    case shop
    case bought
    var str: String {
        switch self {
        case .shop:
            return "와인샵"
        case .bought:
            return "구매와인"
        }
    }
}

struct GraphResource {
    let type: GraphType
    let cntArr: [Int]
}

class DonutGraphView: UIView {
    var graphResource: GraphResource?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        guard let graphResource = graphResource else { return }
        let colors: [UIColor]
        let values: [CGFloat]
        
        if graphResource.type == .shop{
            colors = StoreType.allOfCases.compactMap { $0.color }
            values = fromIntToPercent(graphResource.cntArr).compactMap { CGFloat($0)}
        } else {
            colors = WineType.allCases.compactMap { $0.color }
            values = fromIntToPercent(graphResource.cntArr).compactMap { CGFloat($0)}
        }
        
        var startAngle: CGFloat = (-(.pi) / 2)
        var endAngle: CGFloat = 0.0
        
        for (idx, value) in values.enumerated() {
            endAngle = value * (.pi * 2)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: 60,
                        startAngle: startAngle,
                        endAngle: startAngle + endAngle,
                        clockwise: true)
            
            colors[idx].set()
            path.fill()
            startAngle += endAngle
            path.close()
            
            // slice space
            UIColor.white.set()
            path.lineWidth = 3
            path.stroke()
        }
        
        let semiCircle = UIBezierPath(arcCenter: center,
                                      radius: 50,
                                      startAngle: 0,
                                      endAngle: (360 * .pi) / 180,
                                      clockwise: true)
        UIColor.white.set()
        semiCircle.fill()
    }
    
    private func fromIntToPercent(_ values: [Int]) -> [Double]{
        let total = values.reduce(0, +)
        return values.compactMap { Double($0) / Double(total) }
    }
}
