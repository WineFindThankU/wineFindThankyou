//
//  WineInfoTableViewCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/23.
//

import Foundation
import UIKit

class WineInfoTableViewCell: UITableViewCell {
    struct WineInfoDetailsView {
        let cepage : WineInfoDetailView
        let from : WineInfoDetailView
        let vintage : WineInfoDetailView
        let alchol : WineInfoDetailView
    }
    
    var wineStoreInfo: WineStoreInfo?
    var wineInfo: WineInfo? {
        didSet { updateUI() }
    }
    var storeBtnClosure: (() -> Void)?
    
    private weak var wineImg: UIImageView?
    private weak var tagLabel: UILabel?
    private weak var deleteBtn: UIButton?
    private weak var wineKorName: UILabel?
    private weak var wineEngName: UILabel?
    private var wineInfoDetailsView: WineInfoDetailsView?
    private weak var wineStoreName: UILabel?
    private weak var boughtDate: UILabel?
    
    override func prepareForReuse() {
        wineInfoDetailsView = nil
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraint()
    }
    
    private func updateUI() {
        guard let wineInfo = wineInfo else { return }
        wineImg?.image = wineInfo.img
        tagLabel?.backgroundColor = wineInfo.wineType.color
        tagLabel?.text = wineInfo.wineType.str
        wineKorName?.text = wineInfo.korName
        wineEngName?.text = wineInfo.engName
        
        wineInfoDetailsView?.cepage.info = ("품종", wineInfo.cepage)
        wineInfoDetailsView?.from.info = ("생산지", wineInfo.from)
        wineInfoDetailsView?.vintage.info = ("빈티지", wineInfo.vintage)
        wineInfoDetailsView?.alchol.info = ("도수", wineInfo.alchol)
        wineStoreName?.text = wineStoreInfo?.storeName
        boughtDate?.text = wineInfo.boughtDate.yyyyMMdd()
    }
    
    private func setConstraint() {
        setWineImageView()
        setConstraintAtWineInfoDetailsView(setWineInfoView())
        setWineShopButton()
    }
    
    private func setWineImageView() {
        let wineImgView = UIImageView()
        contentView.addSubview(wineImgView)
        wineImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wineImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            wineImgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            wineImgView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -270),
            wineImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -67),
        ])
        
        wineImgView.image = UIImage(named: "icon")
        wineImgView.contentMode = .scaleAspectFill
        self.wineImg = wineImgView
    }
    
    private func setWineInfoView() -> UIView {
        let wineInfoView = UIView()
        contentView.addSubview(wineInfoView)
        wineInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let tagLabel = TagLabel()
        let deleteBtn = UIButton()
        let wineKorName = UILabel()
        let wineEngName = UILabel()
        let wineInfoDetailsView = UIView()
        
        wineInfoView.addSubViews(subViews: tagLabel, deleteBtn, wineKorName, wineEngName, wineInfoDetailsView)
        NSLayoutConstraint.activate([
            wineInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            wineInfoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 113),
            wineInfoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            wineInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -67),
            
            tagLabel.topAnchor.constraint(equalTo: wineInfoView.topAnchor),
            tagLabel.leftAnchor.constraint(equalTo: wineInfoView.leftAnchor),
            tagLabel.heightAnchor.constraint(equalToConstant: 18),
            
            deleteBtn.topAnchor.constraint(equalTo: wineInfoView.topAnchor),
            deleteBtn.rightAnchor.constraint(equalTo: wineInfoView.rightAnchor),
            deleteBtn.widthAnchor.constraint(equalToConstant: 28),
            deleteBtn.heightAnchor.constraint(equalToConstant: 18),
            
            wineKorName.topAnchor.constraint(equalTo: wineInfoView.topAnchor, constant: 22),
            wineKorName.leftAnchor.constraint(equalTo: wineInfoView.leftAnchor),
            wineKorName.rightAnchor.constraint(equalTo: wineInfoView.rightAnchor),
            
            wineEngName.topAnchor.constraint(equalTo: wineKorName.bottomAnchor, constant: 4),
            wineEngName.leftAnchor.constraint(equalTo: wineInfoView.leftAnchor),
            wineEngName.rightAnchor.constraint(equalTo: wineInfoView.rightAnchor),
            
            wineInfoDetailsView.topAnchor.constraint(equalTo: wineEngName.bottomAnchor, constant: 8),
            wineInfoDetailsView.leftAnchor.constraint(equalTo: wineInfoView.leftAnchor),
            wineInfoDetailsView.rightAnchor.constraint(equalTo: wineInfoView.rightAnchor),
            wineInfoDetailsView.bottomAnchor.constraint(equalTo: wineInfoView.bottomAnchor),
        ])
        
        tagLabel.font = UIFont.systemFont(ofSize: 11)
        tagLabel.textColor = .white
        tagLabel.textAlignment = .center
        tagLabel.clipsToBounds = true
        tagLabel.layer.cornerRadius = 7
        
        deleteBtn.setTitle("삭제", for: .normal)
        deleteBtn.setTitleColor(UIColor(rgb: 0x9e9e9e), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
    
        wineKorName.textColor = UIColor(rgb: 0x1e1e1e)
        wineKorName.font = UIFont.systemFont(ofSize: 13)
        wineKorName.numberOfLines = 0
        
        wineEngName.textColor = UIColor(rgb: 0x757575)
        wineEngName.font = UIFont.systemFont(ofSize: 11)
        wineEngName.numberOfLines = 0
        
        self.tagLabel = tagLabel
        self.deleteBtn = deleteBtn
        self.wineKorName = wineKorName
        self.wineEngName = wineEngName
        
        return wineInfoDetailsView
    }
    
    private func setConstraintAtWineInfoDetailsView(_ wineInfoDetailsView: UIView){
        let cepage = WineInfoDetailView()
        let from = WineInfoDetailView()
        let vintage = WineInfoDetailView()
        let alchol = WineInfoDetailView()
        wineInfoDetailsView.addSubview(cepage.superView)
        wineInfoDetailsView.addSubview(from.superView)
        wineInfoDetailsView.addSubview(vintage.superView)
        wineInfoDetailsView.addSubview(alchol.superView)
        
        cepage.superView.translatesAutoresizingMaskIntoConstraints = false
        from.superView.translatesAutoresizingMaskIntoConstraints = false
        vintage.superView.translatesAutoresizingMaskIntoConstraints = false
        alchol.superView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cepage.superView.topAnchor.constraint(equalTo: wineInfoDetailsView.topAnchor),
            cepage.superView.leftAnchor.constraint(equalTo: wineInfoDetailsView.leftAnchor),
            cepage.superView.rightAnchor.constraint(equalTo: wineInfoDetailsView.rightAnchor),
            cepage.superView.heightAnchor.constraint(equalToConstant: 13),

            from.superView.topAnchor.constraint(equalTo: cepage.superView.bottomAnchor, constant: 4),
            from.superView.leftAnchor.constraint(equalTo: wineInfoDetailsView.leftAnchor),
            from.superView.rightAnchor.constraint(equalTo: wineInfoDetailsView.rightAnchor),
            from.superView.heightAnchor.constraint(equalToConstant: 13),

            vintage.superView.topAnchor.constraint(equalTo: from.superView.bottomAnchor, constant: 4),
            vintage.superView.leftAnchor.constraint(equalTo: wineInfoDetailsView.leftAnchor),
            vintage.superView.rightAnchor.constraint(equalTo: wineInfoDetailsView.rightAnchor),
            vintage.superView.heightAnchor.constraint(equalToConstant: 13),

            alchol.superView.topAnchor.constraint(equalTo: vintage.superView.bottomAnchor, constant: 4),
            alchol.superView.leftAnchor.constraint(equalTo: wineInfoDetailsView.leftAnchor),
            alchol.superView.rightAnchor.constraint(equalTo: wineInfoDetailsView.rightAnchor),
            alchol.superView.heightAnchor.constraint(equalToConstant: 13),
        ])
        self.wineInfoDetailsView = WineInfoDetailsView(cepage: cepage, from: from, vintage: vintage, alchol: alchol)
    }
    
    private func setWineShopButton() {
        let buttonView = UIButton()
        self.contentView.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImageView()
        let name = UILabel()
        let date = UILabel()
        let btn = UIButton()
        buttonView.addSubViews(subViews: img, name, date, btn)
        
        NSLayoutConstraint.activate([
            buttonView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            buttonView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            buttonView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -17),
            buttonView.heightAnchor.constraint(equalToConstant: 36),
            
            btn.topAnchor.constraint(equalTo: buttonView.topAnchor),
            btn.leftAnchor.constraint(equalTo: buttonView.leftAnchor),
            btn.rightAnchor.constraint(equalTo: buttonView.rightAnchor),
            btn.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
            
            img.leftAnchor.constraint(equalTo: buttonView.leftAnchor, constant: 12),
            img.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            img.widthAnchor.constraint(equalToConstant: 20),
            img.heightAnchor.constraint(equalToConstant: 20),
            
            name.leftAnchor.constraint(equalTo: img.rightAnchor, constant: 8),
            name.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            name.widthAnchor.constraint(equalToConstant: 200),
            
            date.rightAnchor.constraint(equalTo: buttonView.rightAnchor, constant: -12),
            date.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
        
        buttonView.layer.borderWidth = 2
        buttonView.layer.borderColor = UIColor(rgb: 0xe0e0e0).cgColor
        buttonView.layer.cornerRadius = 8
        
        img.image = UIImage(named: "StoreIcon")
        
        name.setTitle(title: "", colorHex: 0x7B61FF, font: .systemFont(ofSize: 11))
        date.setTitle(title: "", colorHex: 0x9e9e9e, font: .systemFont(ofSize: 11))
        wineStoreName = name
        boughtDate = date
        
        btn.addAction(UIAction(handler: { _ in self.storeBtnClosure?() }), for: .touchUpInside)
    }
}
extension WineInfoTableViewCell {
    @objc
    private func goToStore() {
        
    }
}
extension Date {
    func yyyyMMdd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd(E)"
        return dateFormatter.string(from: self)
    }
}
