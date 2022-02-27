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
        return wineStoreInfo?.wines.count ?? 0 >= 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testCode()
        
        setTopView()
        setContentsView()
        registerAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewTopAnchor.constant = UIScreen.main.bounds.height - 267
        guard wineStoreInfo?.wines.count ?? 0 > 0 else {
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
        
        storeName.text = wineStoreInfo?.storeName ?? ""
        storeName.font = .boldSystemFont(ofSize: 20)
        storeName.textColor = Theme.blacktext.color
        storeClassification.text = wineStoreInfo?.classification.str ?? ""
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
        guard let wines = wineStoreInfo?.wines else { return 0 }
        return wines.count > 3 ? 3 : wines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell,
              let wineStoreInfo = wineStoreInfo
        else { return UICollectionViewCell() }
        cell.wineInfo = wineStoreInfo.wines[indexPath.row]
        
        if indexPath.row == 2, isMoreThree {
            cell.setMoreView(wineStoreInfo.wines.count - 3)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: StoryBoard.store.name, bundle: nil)
        guard indexPath.row == 2, isMoreThree, let vc = storyBoard.instantiateViewController(withIdentifier: StoreInfoViewController.identifier) as? StoreInfoViewController else {
                goToStoreInfoVC()
                return
        }
        vc.wineStoreInfo = self.wineStoreInfo
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        func goToStoreInfoVC() {
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "StoreWinesViewController") as? StoreWinesViewController else {
                 return
            }
            vc.crntIndex = indexPath.row
            vc.wines = self.wineStoreInfo?.wines ?? []
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension StoreInfoSummaryViewController {
    func testCode() {
        //MARK: TEST CODE
        self.wineStoreInfo = WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                           classification: .privateShop,
                                           callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                           openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                           wines: [])
        getWines().forEach { self.wineStoreInfo?.addWines($0) }
        getWines().forEach { self.wineStoreInfo?.addWines($0) }
        getWines().forEach { self.wineStoreInfo?.addWines($0) }
    }
    
    private func getWines() -> [WineInfo] {
        guard let img = UIImage(named: "TestWineImg") else { return [] }
    
        var wineInfos = [WineInfo]()
        wineInfos.append(
            WineInfo(img: img,
                     korName: "비카스 초이스 소비뇽 블랑 스파클링",
                     engName: "Vicar's Choice Sauvignon Blanc Bubbles",
                     wineType: WineType.sparkling,
                     cepage: "소비뇽 블랑 (Sauvignon Blanc)",
                     from: "뉴질랜드",
                     vintage: "2010",
                     alchol: "Alc. 15%")
        )
        
        wineInfos.append(
            WineInfo(img: img,
                     korName: "카피텔 산 로코 발폴리첼라 리파쏘 수페리오레",
                     engName: "Capitel San Rocco Valpolicella Ripasso Superiore",
                     wineType: WineType.red,
                     cepage: "코르비나(Corvina), 코르비노네(Corvinone), 론디넬라(Rondinella), 기타(Others)",
                     from: "아르헨티나",
                     vintage: "2010",
                     alchol: "Alc. 15%")
        )
        
        wineInfos.append(
            WineInfo(img: img,
                     korName: "젠틀 타이거 화이트",
                     engName: "Gentle Tiger White",
                     wineType: WineType.white,
                     cepage: "샤르도네 (Chardonnay), 비우라 (Viura)",
                     from: "뉴질랜드",
                     vintage: "2010",
                     alchol: "Alc. 15%")
        )
        
        return wineInfos
    }
}
