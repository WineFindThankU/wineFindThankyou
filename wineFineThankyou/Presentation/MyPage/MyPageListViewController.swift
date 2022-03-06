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
    
    internal var wineStoreInfos: [WineStoreInfo] = []
    internal var wineInfos: [WineInfo] = []
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
        
        plusButton.backgroundColor = .clear
        plusButton.setBackgroundImage(UIImage(named: "PlusButton"), for: .normal)
        plusButton.addTarget(self, action: #selector(touchPlusButton), for: .touchUpInside)
        self.view.bringSubviewToFront(plusButton)
        
        self.tableView = tableView
    }
    
    @objc
    func touchPlusButton() {
        guard let vc = UIStoryboard(name: StoryBoard.main.name, bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        else { return }
        
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    @objc
    func goToStore(_ storeKey: Int) {
        guard let vc = UIStoryboard(name: StoryBoard.store.name, bundle: nil).instantiateViewController(withIdentifier: StoreInfoViewController.identifier) as? StoreInfoViewController else { return }
        vc.wineInfos = wineInfos.filter { $0.storeFk == storeKey }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
}
