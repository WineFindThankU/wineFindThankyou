//
//  MainViewController.swift
//  wineFindThankyou
//
//  Created by betty on 2022/01/23.
//

import UIKit
import SnapKit
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
   
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: NMFMapView!
    
    @IBOutlet weak var searchButtonOutlet: UIButton!
    var wineStoreInfo: WineStoreInfo?
    override func viewDidLoad() {
            super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //MARK: TEST
        rightBtn.addTarget(self, action: #selector(openStore), for: .touchUpInside)
    }
    
    @objc
    private func openStore() {
        loadStoreInfoFromServer {
            guard $0 else { return }
            showStoreInfoSummary()
        }
        
        func showStoreInfoSummary() {
            
//             let bundle = Bundle(for: CustomView.self)
//                 bundle.loadNibNamed("CustomView", owner: self, options: nil)
//                 addSubview(customView)
//                 customView.frame = self.bounds
//             let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//
             guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreInfoSummaryViewController") as? StoreInfoSummaryViewController  else { return }
             
             vc.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
    
    private func loadStoreInfoFromServer(done: ((Bool) -> Void)?) {
        //MARK: 문용. storeInfoFromServer
        done?(true)
    }
    
    
    func getShopLists() {
        let requestNetworking = RequestNetworking()
        requestNetworking.getShopsList()
    }
   
    
    
    @IBAction func onClickSearchBar(_ sender: UIButton) {
        print(sender)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
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
