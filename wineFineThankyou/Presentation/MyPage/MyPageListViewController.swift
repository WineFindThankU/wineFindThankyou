//
//  MyPageListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/26.
//

import Foundation
import UIKit

class MyPageListViewController: UIViewController {
    unowned var tableView: UITableView!
    internal var titleLabel: UILabel?
    internal var shops: [VisitedShop] = []
    internal var boughtWines: [BoughtWine] = []
    internal var deleteProtocol: DeleteProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
    }
    
    private func setConstraint() {
        let topView = getGlobalTopView(self.view, height: 44)
        let tableView = UITableView()
        let plusButton = UIButton()
        
        self.view.addSubview(tableView)
        self.view.addSubview(plusButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            plusButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -33),
            plusButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -33),
            plusButton.widthAnchor.constraint(equalToConstant: 66),
            plusButton.heightAnchor.constraint(equalToConstant: 66),
        ])
        
        topView.backgroundColor = .clear
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        titleLabel = topView.titleLabel
        
        plusButton.layer.cornerRadius = 33
        plusButton.backgroundColor = .clear
        plusButton.setBackgroundImage(UIImage(named: "PlusButton"), for: .normal)
        plusButton.addAction(UIAction { _ in
            touchPlusButton(self)
        }, for: .touchUpInside)
        self.view.bringSubviewToFront(plusButton)
        
        self.tableView = tableView
    }
    
    
    
    @objc
    func goToShop(_ shopKey: String) {
        guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoViewController.identifier) as? ShopInfoViewController
        else { return }
        
        AFHandler.shopDetail(shopKey) {
            guard let shop = $0 else { return }
            vc.shop = shop
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
}
