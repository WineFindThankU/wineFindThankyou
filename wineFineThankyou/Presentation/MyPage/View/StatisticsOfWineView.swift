//
//  StatisticsOfWineView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/19.
//

import Foundation
import UIKit

class StatisticsOfWineView: UIView {
    @IBOutlet private var backView: UIView!
    @IBOutlet private weak var donutGraphOfSuper: UIView!
    @IBOutlet weak var stackSuperView: UIView!
    @IBOutlet private weak var donutLabel: UILabel!
    private weak var donutGraph: DonutGraphView!
    
    internal var graphResource: GraphResource? {
        didSet {
            guard let graphResource = graphResource else {
                return
            }
            self.donutGraph.graphResource = graphResource
            setDonutLabel(graphResource)
            setStackView(graphResource)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        Bundle.main.loadNibNamed("StatisticsOfWineView", owner: self, options: nil)
        addSubview(backView)
        let graphFrame = CGRect(x: 0, y: 0, width: donutGraphOfSuper.frame.width, height: donutGraphOfSuper.frame.height)
        let graph = DonutGraphView(frame: graphFrame)
        donutGraphOfSuper.addSubview(graph)
        self.donutGraph = graph
        donutGraph.backgroundColor = .clear
        donutGraphOfSuper.backgroundColor = .clear
    }
    
    private func setDonutLabel(_ resource: GraphResource) {
        donutLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        donutLabel.textColor = UIColor(rgb: 0x424242)
        donutLabel.numberOfLines = 0
        let total = resource.cntArr.reduce(0, +)
        
        let totalTxt = resource.type.str
                        + "\n\(total)"
        donutLabel.attributedText = totalTxt.rangeSizeUp(22, font: .light, range: "\(total)")
        donutLabel.textAlignment = .center
        donutGraphOfSuper.bringSubviewToFront(donutLabel)
    }
    
    private func setStackView(_ resource: GraphResource) {
        let tdStackView = TypeDetailStackView(frame: CGRect(x: 0, y: 0, width: stackSuperView.frame.width, height: stackSuperView.frame.height))
        stackSuperView.addSubview(tdStackView)
        tdStackView.resource = resource
    }
}
