//
//  StoreInfoSummaryViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

class StoreInfoSummaryViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var contentsView: UIView!
    @IBOutlet private weak var contentsTopView: UIView!
    @IBOutlet private weak var contentsButtonView: UIView!
    @IBOutlet private weak var emptyView: UIImageView!
    @IBOutlet private weak var winesCollectionView: UICollectionView!
    @IBOutlet weak var viewTopAnchor: NSLayoutConstraint!
    
    private var storeButtonsView: StoreButtonsView?
    internal var wineStoreInfo: WineStoreInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        backgroundView.backgroundColor = .clear
        //MARK: TEST CODE
        self.wineStoreInfo = WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                           classification: .privateShop,
                                           callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                           openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                           wines: [])
        registerAction()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard wineStoreInfo?.wines.count ?? 0 > 0 else {
            emptyView.isHidden = false
            winesCollectionView.isHidden = true
            viewTopAnchor.constant = UIScreen.main.bounds.height - 267
            return
        }
        emptyView.isHidden = true
        winesCollectionView.isHidden = false
    }
    
    private func configure() {
        setTopView()
        storeButtonsView = setStoreButtonView(superView: contentsButtonView, contentsTopView)
        storeButtonsView?.left?.btnAction = {
            //즐겨찾기 추가 기능
        }
        storeButtonsView?.middle?.btnAction = {
            //길찾기 버튼
        }
        storeButtonsView?.right?.btnAction = {
            //사진찍기 버튼
        }
        
        winesCollectionView.delegate = self
        winesCollectionView.dataSource = self
        winesCollectionView.register(UINib(nibName: "WineInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WineInfoCollectionViewCell")
        winesCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
    }
    
    private func registerAction() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        self.backgroundView.addGestureRecognizer(gesture)
        self.backgroundView.isUserInteractionEnabled = true
    }
    
    private func setTopView() {
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
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        storeName.text = wineStoreInfo?.storeName ?? ""
        storeName.font = .boldSystemFont(ofSize: 20)
        storeName.textColor = Theme.blacktext.color
        storeClassification.text = wineStoreInfo?.classification.str ?? ""
        storeClassification.font = .systemFont(ofSize: 13)
        storeClassification.textColor = Theme.blacktext.color
        imageView.image = UIImage(named: "rightArrow")
        rightButton.addTarget(self, action: #selector(goToStore), for: .touchUpInside)
    }
    
    
    @objc
    private func goToStore() {
        print("gotoStore")
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreInfoViewController") as? StoreInfoViewController else { return }
        vc.wineStoreInfo = wineStoreInfo
        
        self.present(vc, animated: true, completion: {

        })
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
}

extension StoreInfoSummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wineStoreInfo?.wines.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell,
              let wineInfo = wineStoreInfo?.wines[indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.img.isHidden = true
        cell.contentView.backgroundColor = UIColor.systemPink
        cell.name.text = wineInfo.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("munyong > selected")
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreWinesViewController") as? StoreWinesViewController else {
             return
        }
        vc.crntIndex = indexPath.row
        vc.wines = self.wineStoreInfo?.wines ?? []
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 129)
    }
    
    class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
        let cellSpacing: CGFloat = 10
     
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            self.minimumLineSpacing = 10.0
            self.sectionInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 0.0, right: 16.0)
            let attributes = super.layoutAttributesForElements(in: rect)
     
            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            attributes?.forEach { layoutAttribute in
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + cellSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
            return attributes
        }
    }
}
