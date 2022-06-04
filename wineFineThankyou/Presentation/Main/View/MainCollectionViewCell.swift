//
//  MainCollectionViewCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/09.
//

import Foundation
import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = MainCollectionViewCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private let titleLabel: UILabel = UILabel()
    private var titleImage: UIImage = UIImage()
    
    override var isSelected: Bool {
        didSet{
            isSelected ? selected() : deselected()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupView() {
        backgroundColor = .white
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
    func configure(type: ShopType) {
        titleLabel.setTitle(title: type.str, txtColor: type.color, font: .systemFont(ofSize: 15))
        self.backgroundColor = .white
    }
    
    func selected() {
        guard let backColor = self.backgroundColor,
              let titleColor =  titleLabel.textColor else { return }
        
        titleLabel.setTitleColor(txt: backColor)
        self.backgroundColor = titleColor
    }
    
    func deselected() {
        guard let str = titleLabel.text,
                let type = ShopType.filteredAllOfCases.first(where: {$0.str == str})
        else { return }
        
        titleLabel.setTitle(title: type.str, txtColor: type.color, font: .systemFont(ofSize: 15))
        self.backgroundColor = .white
    }
}
