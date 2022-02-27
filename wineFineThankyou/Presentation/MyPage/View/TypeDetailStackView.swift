//
//  TypeDetailStackView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/19.
//

import Foundation
import UIKit
class TypeDetailStackView: UIView{
    @IBOutlet private var backView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    var resource: GraphResource? {
        didSet {
            updateUI()
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
        Bundle.main.loadNibNamed("TypeDetailStackView", owner: self, options: nil)
        addSubview(backView)
    }
    
    func updateUI() {
        guard let resource = resource else { return }
        
        let titles: [String]
        let colors: [UIColor]
        if resource.type == .shop {
            titles = ShopType.allCases.compactMap { $0.str }
            colors = ShopType.allCases.compactMap { $0.color }
        } else {
            titles = WineType.allCases.compactMap { $0.str }
            colors = WineType.allCases.compactMap { $0.color } + [UIColor(rgb: 0x000000)]
        }
        
        for (idx, color) in colors.enumerated() {
            let detailStacked = DetailStacked()
            stackView.addArrangedSubview(detailStacked)
            guard color != UIColor(rgb: 0x000000) else {
                return
            }
            detailStacked.details = (colors[idx], titles[idx], resource.cntArr[idx])
        }
    }
}

class DetailStacked: UIView {
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let count: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var details: (color: UIColor, title: String, count: Int)? {
        didSet {
            guard let details = self.details else { return }
            self.colorView.backgroundColor = details.color
            self.title.text = details.title
            self.count.text = String(details.count)
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
    
    func configure() {
        addSubview(colorView)
        addSubview(title)
        addSubview(count)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 8),
            colorView.heightAnchor.constraint(equalToConstant: 8),
            colorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            colorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            title.leftAnchor.constraint(equalTo: colorView.rightAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),

            count.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 4),
            count.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
        
        colorView.layer.cornerRadius = 4
        title.font = UIFont.systemFont(ofSize: 11)
        title.textColor = UIColor(rgb: 0x424242)
        count.textColor = UIColor(rgb: 0x9e9e9e)
        count.font = UIFont.systemFont(ofSize: 11)
    }
}
