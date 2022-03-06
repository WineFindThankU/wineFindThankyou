//
//  StoreInfoSummaryViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

class StoreInfoSummaryViewController: ContainStoreButtonViewController, UIGestureRecognizerDelegate {
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var contentsView: UIView!
    @IBOutlet private weak var contentsTopView: UIView!
    @IBOutlet private weak var contentsButtonView: UIView!
    @IBOutlet private weak var emptyView: UIImageView!
    @IBOutlet private weak var winesCollectionView: UICollectionView!
    @IBOutlet weak var viewTopAnchor: NSLayoutConstraint!
    
    private var isMoreThree: Bool {
        return wineInfos.count >= 3
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
        guard wineInfos.count > 0 else {
            emptyView.isHidden = false
            winesCollectionView.isHidden = true
            
            return
        }
        
        emptyView.isHidden = true
        winesCollectionView.isHidden = false
    }
    
    private func setContentsView() {
        self.view.backgroundColor = .clear
        backgroundView.backgroundColor = .clear
        contentsView.layer.cornerRadius = 12
        storeButtonsView = setStoreButtonView(superView: contentsButtonView, contentsTopView)
        winesCollectionView.delegate = self
        winesCollectionView.dataSource = self
        winesCollectionView.register(UINib(nibName: "WineInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WineInfoCollectionViewCell")
    }
    
    func setTopView() {
        let storeName = UILabel()
        let storeClassification = UILabel()
        let rightButton = UIButton()
        let imageView = UIImageView()
        
        contentsTopView.addSubview(storeName)
        contentsTopView.addSubview(storeClassification)
        contentsTopView.addSubview(rightButton)
        contentsTopView.addSubview(imageView)
        
        storeName.translatesAutoresizingMaskIntoConstraints = false
        storeClassification.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            storeName.topAnchor.constraint(equalTo: contentsTopView.topAnchor),
            storeName.leftAnchor.constraint(equalTo: contentsTopView.leftAnchor, constant: 17),
            storeName.widthAnchor.constraint(equalToConstant: 217),
            
            storeClassification.leftAnchor.constraint(equalTo: storeName.rightAnchor, constant: 8),
            storeClassification.bottomAnchor.constraint(equalTo: storeName.bottomAnchor),
            
            rightButton.topAnchor.constraint(equalTo: contentsTopView.topAnchor),
            rightButton.leftAnchor.constraint(equalTo: contentsTopView.leftAnchor),
            rightButton.rightAnchor.constraint(equalTo: contentsTopView.rightAnchor),
            rightButton.bottomAnchor.constraint(equalTo: contentsTopView.bottomAnchor),
            
            imageView.rightAnchor.constraint(equalTo: contentsTopView.rightAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: storeName.centerYAnchor),
        ])
        
        storeName.text = shopInfo.name
        storeName.font = .boldSystemFont(ofSize: 20)
        storeName.textColor = Theme.blacktext.color
        storeClassification.text = shopInfo.categoryType.str
        storeClassification.font = .systemFont(ofSize: 13)
        storeClassification.textColor = Theme.blacktext.color
        imageView.image = UIImage(named: "rightArrow")
        rightButton.addTarget(self, action: #selector(goToStore), for: .touchUpInside)
    }
    
    private func registerAction() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        self.backgroundView.addGestureRecognizer(gesture)
        self.backgroundView.isUserInteractionEnabled = true
    }
}

extension StoreInfoSummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wineInfos.count > 3 ? 3 : wineInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell
        else { return UICollectionViewCell() }
        cell.wineInfo = wineInfos[indexPath.row]
        
        if indexPath.row == 2, isMoreThree {
            cell.setMoreView(wineInfos.count - 3)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: StoryBoard.store.name, bundle: nil)
        guard indexPath.row == 2, isMoreThree else {
            goToStoreInfoVC()
            return
        }
        goToStore()
        
        func goToStoreInfoVC() {
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "StoreWinesViewController") as? StoreWinesViewController else {
                 return
            }
            vc.crntIndex = indexPath.row
            vc.wineInfos = wineInfos
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
