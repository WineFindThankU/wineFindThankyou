//
//  MainViewController.swift
//  wineFindThankyou
//
//  Created by betty on 2022/01/23.
//

import UIKit
import NMapsMap
class MainViewController: UIViewController {
    
    private let arrCategoryName: [String] = [
            "전체 ",
            "개인샵",
            "체인샵",
            "치즈볼",
            "편의점",
            "대형마트",
            "창고형매장",
            "백화점"
    ]
    
   
    var arrCategoryImage: [String] = ["Tag","Tag","Tag","Tag","Tag","Tag","Tag","Tag"]
  //  @IBOutlet weak var mapView: NMFMapView!
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: NMFMapView!
    weak var storeSummaryView : StoreSumamryView?
    override func viewDidLoad() {
            super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        showSummaryView()
    }
    
    private func showSummaryView() {
        let storeSummaryView = StoreSumamryView()
        self.mapView.addSubview(storeSummaryView)
        storeSummaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storeSummaryView.leftAnchor.constraint(equalTo: self.mapView.leftAnchor),
            storeSummaryView.rightAnchor.constraint(equalTo: self.mapView.rightAnchor),
            storeSummaryView.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor),
            storeSummaryView.heightAnchor.constraint(equalToConstant: 267)
        ])
        storeSummaryView.topView?.storeName.text = "뱅가드 와인 머천트 분당지점"
        storeSummaryView.topView?.storeClassification.text = "개인샵"
        storeSummaryView.topView?.rightButton.addTarget(self, action: #selector(goToStore), for: .touchUpInside)
        storeSummaryView.topView?.rightButton.setBackgroundImage(UIImage(named: "rightArrow"), for: .normal)
        
        self.storeSummaryView = storeSummaryView
    }
    
    @objc private func goToStore() {
        print("goToStore")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategoryName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
        cell.imageCell.image = UIImage(named: arrCategoryImage[indexPath.row]) ?? UIImage()
        cell.labelCell.text = arrCategoryName[indexPath.row]
        return cell
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width / 3 - 1.0
        
        return CGSize(width: width, height: width)
    }
    
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}
