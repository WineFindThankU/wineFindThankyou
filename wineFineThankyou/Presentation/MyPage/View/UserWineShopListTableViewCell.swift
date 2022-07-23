//
//  UserWineShopListTableViewCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/25.
//

import Foundation
import UIKit

class UserWineShopListTableViewCell: UITableViewCell {
    private unowned var imgView: UIImageView!
    private unowned var deleteBtn: UIButton!
    private unowned var tagLabel: TagLabel!
    private unowned var shopName: UILabel!
    private unowned var registeredWineCount: UILabel!
    
    internal var isVisitedType = false {
        didSet {
            self.deleteBtn.isHidden = !isVisitedType
        }
    }
    internal var wineCount = 0
    internal var deleteClosure: (() -> Void)?
    internal var shop: VisitedShop? {
        didSet { updateUI() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDetailConstraint(detailView: setConstraint())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDetailConstraint(detailView: setConstraint())
    }
    
    @objc
    private func deleteBtnAction() {
        self.deleteClosure?()
    }
    
    private func updateUI() {
        guard let shop = shop?.shopDetail else { return }
        
        tagLabel.setTitle(title: shop.shopType.str, colorHex: 0xffffff,
                          backColor: shop.shopType.color,
                          font: .systemFont(ofSize: 11))
        shopName.setTitle(title: shop.name, colorHex: 0x1e1e1e, font: .systemFont(ofSize: 13))
        registeredWineCount.setTitle(title: "등록한 와인 \(wineCount)", colorHex: 0x757575, font: .systemFont(ofSize: 11))
        
        guard let imgUrlStr = shop.imgUrlStr
        else { return }
        
        self.imgView.setImage(by: imgUrlStr)
    }
    
    private func setDetailConstraint(detailView: UIView) {
        let deleteBtn = UIButton()
        let tagLabel = TagLabel()
        let shopName = UILabel()
        let registeredWineCount = UILabel()
        detailView.addSubViews(deleteBtn, tagLabel, shopName, registeredWineCount)
        NSLayoutConstraint.activate([
            deleteBtn.topAnchor.constraint(equalTo: detailView.topAnchor),
            deleteBtn.rightAnchor.constraint(equalTo: detailView.rightAnchor),
            deleteBtn.widthAnchor.constraint(equalToConstant: 22),
            deleteBtn.heightAnchor.constraint(equalToConstant: 14),
            
            tagLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 13),
            tagLabel.leftAnchor.constraint(equalTo: detailView.leftAnchor),
            tagLabel.heightAnchor.constraint(equalToConstant: 18),
            
            shopName.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 4),
            shopName.leftAnchor.constraint(equalTo: detailView.leftAnchor),
            shopName.rightAnchor.constraint(equalTo: detailView.rightAnchor, constant: -20),
            shopName.heightAnchor.constraint(equalToConstant: 18),
            
            registeredWineCount.topAnchor.constraint(equalTo: shopName.bottomAnchor, constant: 2),
            registeredWineCount.leftAnchor.constraint(equalTo: detailView.leftAnchor),
            registeredWineCount.rightAnchor.constraint(equalTo: detailView.rightAnchor, constant: -20),
            registeredWineCount.heightAnchor.constraint(equalToConstant: 13)
            ])
        deleteBtn.setTitle(title: "삭제", colorHex: 0x9e9e9e, font: .systemFont(ofSize: 11))
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        
        tagLabel.clipsToBounds = true
        tagLabel.layer.cornerRadius = 7
        
        self.tagLabel = tagLabel
        self.deleteBtn = deleteBtn
        self.shopName = shopName
        self.registeredWineCount = registeredWineCount
    }
    
    private func setConstraint() -> UIView{
        let imgView = UIImageView()
        let detailView = UIView()
        contentView.addSubview(imgView)
        contentView.addSubview(detailView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            imgView.widthAnchor.constraint(equalToConstant: 80),
            imgView.heightAnchor.constraint(equalToConstant: 80),
            
            detailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            detailView.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 16),
            detailView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            detailView.heightAnchor.constraint(equalToConstant: 80),
            detailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])

        self.imgView = imgView
        return detailView
    }
}
