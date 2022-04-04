//
//  ShopInfoSummaryViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

protocol ReloadShopDetail: AnyObject {
    func addShopDetail(_ shop: Shop)
}

class ShopInfoSummaryViewController: ShopContainedButtonViewController, UIGestureRecognizerDelegate {
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var contentsView: UIView!
    @IBOutlet private weak var contentsTopView: UIView!
    @IBOutlet private weak var contentsButtonView: UIView!
    @IBOutlet private weak var emptyView: UIImageView!
    @IBOutlet private weak var winesCollectionView: UICollectionView!
    @IBOutlet weak var viewTopAnchor: NSLayoutConstraint!
    
    private var isMoreThree: Bool {
        return shop.userWines.count > 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTopView()
        setContentsView()
        registerAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        viewTopAnchor.constant = UIScreen.main.bounds.height - 267
        reloadCollectionView()
    }
    
    private func reloadCollectionView() {
        guard shop.userWines.count > 0 else {
            emptyView.isHidden = false
            winesCollectionView.isHidden = true
            
            return
        }
        
        emptyView.isHidden = true
        winesCollectionView.isHidden = false
        
        self.winesCollectionView.reloadData()
    }
    private func setContentsView() {
        self.view.backgroundColor = .clear
        backgroundView.backgroundColor = .clear
        contentsView.layer.cornerRadius = 12
        shopBtnsView = setShopButtonView(superView: contentsButtonView, contentsTopView)
        winesCollectionView.delegate = self
        winesCollectionView.dataSource = self
        winesCollectionView.register(UINib(nibName: "WineInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WineInfoCollectionViewCell")
    }
    
    func setTopView() {
        let shopName = UILabel()
        let shopClassification = UILabel()
        let rightButton = UIButton()
        let imageView = UIImageView()
        contentsTopView.addSubViews(subViews: shopName, shopClassification,
                                    rightButton, imageView)
        
        NSLayoutConstraint.activate([
            shopName.topAnchor.constraint(equalTo: contentsTopView.topAnchor),
            shopName.leftAnchor.constraint(equalTo: contentsTopView.leftAnchor, constant: 17),
            
            shopClassification.leftAnchor.constraint(equalTo: shopName.rightAnchor, constant: 8),
            shopClassification.bottomAnchor.constraint(equalTo: shopName.bottomAnchor),
            
            rightButton.topAnchor.constraint(equalTo: contentsTopView.topAnchor),
            rightButton.leftAnchor.constraint(equalTo: contentsTopView.leftAnchor),
            rightButton.rightAnchor.constraint(equalTo: contentsTopView.rightAnchor),
            rightButton.bottomAnchor.constraint(equalTo: contentsTopView.bottomAnchor),
            
            imageView.rightAnchor.constraint(equalTo: contentsTopView.rightAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: shopName.centerYAnchor),
        ])
        
        shopName.text = shop.nnName
        shopName.font = .boldSystemFont(ofSize: 20)
        shopName.textColor = Theme.blacktext.color
        shopClassification.text = shop.type?.str
        shopClassification.font = .systemFont(ofSize: 13)
        shopClassification.textColor = Theme.blacktext.color
        imageView.image = UIImage(named: "rightArrow")
        rightButton.addTarget(self, action: #selector(goToShop), for: .touchUpInside)
    }
    
    private func registerAction() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        self.backgroundView.addGestureRecognizer(gesture)
        self.backgroundView.isUserInteractionEnabled = true
    }
}

extension ShopInfoSummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop.userWines.count > 3 ? 3 : shop.userWines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell
        else { return UICollectionViewCell() }
        
        let userWine = shop.userWines[indexPath.row]
        let name = userWine.wineAtServer?.korName ?? userWine.name
        cell.tupleVal = (name, userWine.wineAtServer?.imgUrlStr)
        
        if indexPath.row == 2, isMoreThree {
            cell.setMoreView(shop.userWines.count - 3)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: StoryBoard.shop.name, bundle: nil)
        guard indexPath.row == 2, isMoreThree else {
            goToShopInfoVC()
            return
        }
        goToShop()
        
        func goToShopInfoVC() {
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "ShopWinesViewController") as? ShopWinesViewController else {
                 return
            }
            vc.crntIndex = indexPath.row
            vc.wineInfos = shop.userWines
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension ShopInfoSummaryViewController: ReloadShopDetail {
    func addShopDetail(_ shop: Shop) {
        self.shop = shop
        DispatchQueue.main.async {
            self.reloadCollectionView()
        }
    }
}
