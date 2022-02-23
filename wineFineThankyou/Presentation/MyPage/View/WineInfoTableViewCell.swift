//
//  WineInfoTableViewCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/23.
//

import Foundation
import UIKit

class WineInfoTableViewCell: UITableViewCell {
    private weak var tagLabel: UILabel?
    private weak var wineKorName: UILabel?
    private weak var wineEngName: UILabel?

    var info: WineInfo? {
        didSet {
            setConstraint()
            setWineInfoDetailValue()
        }
    }
    private var cepage: WineInfoDetailView?
    private var from: WineInfoDetailView?
    private var vintage: WineInfoDetailView?
    private var alchol: WineInfoDetailView?
    
    class WineInfoDetailView: UIView {
        let superView = UIView()
        var info: (title: String, content: String)? {
            didSet { configure() }
        }
        
        private func configure() {
            let title = UILabel()
            let content = UILabel()
            superView.addSubview(title)
            superView.addSubview(content)
            superView.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false
            content.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: superView.topAnchor),
                title.leftAnchor.constraint(equalTo: superView.leftAnchor),
                title.widthAnchor.constraint(equalToConstant: 36),
                title.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
                
                content.topAnchor.constraint(equalTo: superView.topAnchor),
                content.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 8),
                content.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -20),
                content.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            ])
            title.text = info?.title
            title.textColor = UIColor(rgb: 0x9e9e9e)
            title.font = UIFont.systemFont(ofSize: 11)
            
            content.text = info?.content
            content.textColor = UIColor(rgb: 0x424242)
            content.font = UIFont.systemFont(ofSize: 11)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConstraint() {
        setWineImageView()
        setConstraintAtWineInfoDetailsView(setWineInfoView())
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
        wineImgView.contentMode = .scaleAspectFit
        wineImgView.backgroundColor = .systemPink
    }
    
    private func setWineInfoView() -> UIView {
        let wineInfoView = UIView()
        contentView.addSubview(wineInfoView)
        wineInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let tag = TagLabel()
        let deleteBtn = UIButton()
        let wineKorName = UILabel()
        let wineEngName = UILabel()
        let wineInfoDetailsView = UIView()
        
        tag.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        wineKorName.translatesAutoresizingMaskIntoConstraints = false
        wineEngName.translatesAutoresizingMaskIntoConstraints = false
        wineInfoDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        wineInfoView.addSubview(wineKorName)
        wineInfoView.addSubview(wineEngName)
        wineInfoView.addSubview(tag)
        wineInfoView.addSubview(deleteBtn)
        wineInfoView.addSubview(wineInfoDetailsView)
        
        NSLayoutConstraint.activate([
            wineInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            wineInfoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 113),
            wineInfoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            wineInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -67),
            
            tag.topAnchor.constraint(equalTo: wineInfoView.topAnchor),
            tag.leftAnchor.constraint(equalTo: wineInfoView.leftAnchor),
            tag.heightAnchor.constraint(equalToConstant: 18),
            
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
        
        tag.font = UIFont.systemFont(ofSize: 11)
        tag.textColor = .white
        tag.backgroundColor = info?.wineType.color ?? WineType.red.color
        tag.text = info?.wineType.str
        
        tag.textAlignment = .center
        tag.clipsToBounds = true
        tag.layer.cornerRadius = 7
        
        deleteBtn.setTitle("삭제", for: .normal)
        deleteBtn.setTitleColor(UIColor(rgb: 0x9e9e9e), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        wineKorName.textColor = UIColor(rgb: 0x1e1e1e)
        wineKorName.font = UIFont.systemFont(ofSize: 13)
        wineKorName.numberOfLines = 0
        wineKorName.text = info?.korName
        
        wineEngName.textColor = UIColor(rgb: 0x757575)
        wineEngName.font = UIFont.systemFont(ofSize: 11)
        wineEngName.numberOfLines = 0
        wineEngName.text = info?.engName
        
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
    }
    
    private func setWineInfoDetailValue() {
        guard let info = info else { return }
        self.cepage?.info = ("품종", info.cepage)
        self.from?.info = ("생산지", info.from)
        self.vintage?.info = ("빈티지", info.vintage)
        self.alchol?.info = ("도수", "Alc. \(info.alchol)%")
    }
}
