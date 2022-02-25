//
//  UserWineShopListTableViewCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/25.
//

import Foundation
import UIKit

class UserWineShopListTableViewCell: UITableViewCell {
    var data: WineStoreInfo? {
        didSet { updateUI() }
    }
    
    private unowned var deleteBtn: UIButton!
    private unowned var tagLabel: UILabel!
    private unowned var shopName: UILabel!
    private unowned var registeredWineCount: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDetailConstraint(detailView: setConstraint())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDetailConstraint(detailView: setConstraint())
    }
    
    private func updateUI() {
        guard let data = data else { return }
        tagLabel.setTitle(title: data.classification.str, colorHex: 0xffffff,
                          backColor: UIColor(rgb: 0x7b61ff),
                          font: .systemFont(ofSize: 11))
        shopName.setTitle(title: data.storeName, colorHex: 0x1e1e1e, font: .systemFont(ofSize: 13))
        registeredWineCount.setTitle(title: "등록한 와인 10", colorHex: 0x757575, font: .systemFont(ofSize: 11))
    }
    
    private func setDetailConstraint(detailView: UIView) {
        let deleteBtn = UIButton()
        let tagLabel = UILabel()
        let shopName = UILabel()
        let registeredWineCount = UILabel()
        detailView.addSubViews(subViews: deleteBtn, tagLabel, shopName, registeredWineCount)
        NSLayoutConstraint.activate([
            deleteBtn.topAnchor.constraint(equalTo: detailView.topAnchor),
            deleteBtn.rightAnchor.constraint(equalTo: detailView.rightAnchor),
            deleteBtn.widthAnchor.constraint(equalToConstant: 22),
            deleteBtn.heightAnchor.constraint(equalToConstant: 14),
            
            tagLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 13),
            tagLabel.leftAnchor.constraint(equalTo: detailView.leftAnchor),
            tagLabel.widthAnchor.constraint(equalToConstant: 41),
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
        
        self.deleteBtn = deleteBtn
        self.tagLabel = tagLabel
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
        
        imgView.image = UIImage(named: "icon")
        imgView.contentMode = .scaleAspectFit

        return detailView
    }
}
