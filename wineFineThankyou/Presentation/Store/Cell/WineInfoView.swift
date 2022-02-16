//
//  WineInfoView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/28.
//

import Foundation
import UIKit

enum TableItem: Int, CaseIterable {
    case cepage = 0
    case from
    case vintage
    case alchol
}

class WineInfoView: UIView{
    @IBOutlet private var contentsView: UIView!
    @IBOutlet private weak var korName: UILabel!
    @IBOutlet private weak var engName: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    internal var wineInfo: WineInfo? = nil {
        didSet{
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
    
    private func configure() {
        Bundle.main.loadNibNamed("WineInfoView", owner: self, options: nil)
        addSubview(contentsView)
        contentsView.backgroundColor = .clear
        korName.font = UIFont.boldSystemFont(ofSize: 15)
        korName.textColor = UIColor(rgb: 0xF5F5F5)
        engName.font = UIFont.systemFont(ofSize: 13)
        engName.textColor = UIColor(rgb: 0xBDBDBD)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WineDetailCell.self, forCellReuseIdentifier: "WineDetailCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 150
    }
    
    private func updateUI() {
        self.korName.text = wineInfo?.korName
        self.engName.text = wineInfo?.engName
        self.tableView.reloadData()
    }
}

extension WineInfoView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WineDetailCell", for: indexPath) as? WineDetailCell
        else { return UITableViewCell() }
        guard let item = TableItem(rawValue: indexPath.row), let wineInfo = self.wineInfo else { return UITableViewCell() }
        
        switch item {
        case .cepage:
            cell.update(("품종", wineInfo.cepage)); return cell
        case .from:
            cell.update(("생산지", wineInfo.from)); return cell
        case .vintage:
            cell.update(("빈티지", wineInfo.vintage)); return cell
        case .alchol:
            cell.update(("도수", wineInfo.alchol)); return cell
        }
    }
}

class WineDetailCell: UITableViewCell {
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    
    private let itemLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let itemContent: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.containerView)
        self.containerView.backgroundColor = .clear
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.itemLabel)
        self.containerView.addSubview(self.itemContent)
        self.itemLabel.translatesAutoresizingMaskIntoConstraints = false
        self.itemContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.itemLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.itemLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.itemLabel.widthAnchor.constraint(equalToConstant: 36),
            
            self.itemContent.leftAnchor.constraint(equalTo: self.itemLabel.rightAnchor, constant: 8),
            self.itemContent.centerYAnchor.constraint(equalTo: self.itemLabel.centerYAnchor)
        ])
        itemLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        itemLabel.textColor = UIColor(rgb: 0x9E9E9E)
        itemContent.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        itemContent.textColor = UIColor(rgb: 0xEEEEEE)
    }
    
    internal func update(_ labelTxt: (item: String, contents: String)) {
        itemLabel.text = labelTxt.item
        itemContent.text = labelTxt.contents
        self.backgroundColor = .clear
    }
}
