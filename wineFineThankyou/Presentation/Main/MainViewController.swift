//
//  MainViewController.swift
//  wineFindThankyou
//
//  Created by betty on 2022/01/23.
//

import UIKit
import SnapKit
import NMapsMap
import RxSwift

class MainViewController: UIViewController {
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nmfNaverMapView: NMFNaverMapView!
    @IBOutlet weak var searchView: UIView!
    private unowned var searchBtn: UIButton!
    private var locationManager : CLLocationManager?

    //근처의 모든 와인샵
    private var allOfWineShopsNearBy: [Shop] = [] {
        didSet {
            if UserData.isConvenienceOn {
                self.shownWineShops = allOfWineShopsNearBy
            } else {
                self.shownWineShops = allOfWineShopsNearBy.filter({$0.type != .convenience})
            }
        }
    }
    
    private var shownWineShops: [Shop] = [] {
        didSet { updateMaker() }
    }
    
    private var type2isSelected: [Int: Bool] = [:]
    private var allOfMarkers = [NMFMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpData()
        self.setupCollectionView()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserLocation()
    }
    private func setUpData() {
        ShopType.filteredAllCases.forEach {
            type2isSelected[$0.rawValue] = ($0 == .all)
        }
    }
    
    private func setupUI() {
        rightBtn.addTarget(self, action: #selector(openMyPage), for: .touchUpInside)
        makeSeachBtnUsingCrntLoc()
        self.nmfNaverMapView.bringSubviewToFront(searchView)
        self.nmfNaverMapView.bringSubviewToFront(filterView)
    }
    
    private func makeSeachBtnUsingCrntLoc() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.nmfNaverMapView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: self.nmfNaverMapView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 27),
        ])
        button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        button.setTitle(title: "이 지역에서 재검색", colorHex: 0x00,
                        backColor: .white, font: .systemFont(ofSize: 12))
        button.layer.cornerRadius = 11
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(showShopsAtCrntLoc), for: .touchDown)
        button.alpha = 0.7
        searchBtn = button
        searchBtn.isHidden = true
    }
    
    internal func whenBeSelectedMarker(_ shop: Shop) {
        guard let shopTypeStr = shop.type?.typeStr,
              let img = UIImage(named: "ShopDetail_\(shopTypeStr)")
        else { return }
        
        let marker: NMFMarker
        if let nnMarker = allOfMarkers.first(where: {
            Int($0.position.lat) == Int(shop.latitude)
            && Int($0.position.lng) == Int(shop.longtitude)
        }) {
            marker = nnMarker
        } else {
            marker = NMFMarker()
            self.allOfMarkers.append(marker)
        }
        
        marker.position = NMGLatLng(lat: shop.latitude, lng: shop.longtitude)
        marker.mapView = self.nmfNaverMapView.mapView
        marker.iconImage = NMFOverlayImage(image: img)
        marker.width = 48
        marker.height = 59
        marker.captionText = shop.nnName
        
        DispatchQueue.main.async {
            self.updateFocus(shop.latitude, shop.longtitude)
            self.openShop(shop.key)
        }
    }
    
    @IBAction func onClickSearchBar(_ sender: UIButton) {
        print(sender)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
         vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension MainViewController {
    @objc
    private func openMyPage() {
        guard let vc = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil).instantiateViewController(withIdentifier: MyPageViewController.identifier) as? MyPageViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        
        //TODO: 마이페이지 AFHandler호출 후 present
        AFHandler.getMyPageData {
            guard let myPageData = $0 else { return }
            vc.user = myPageData.user
            vc.visitedWineShops = myPageData.visitedShops
            vc.favoritesWineShops = myPageData.bookmarkedShops
            vc.boughtWines = myPageData.boughtWines
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
    }
    
    @objc
    func showShopsAtCrntLoc() {
        let crntLoc = self.nmfNaverMapView.mapView.cameraPosition.target
        DispatchQueue.global().async {
            AFHandler.shopList(crntLoc.lat, crntLoc.lng) { shopList in
                self.allOfWineShopsNearBy.removeAll()
                self.allOfWineShopsNearBy.append(contentsOf: shopList)
                DispatchQueue.main.async {
                    self.setUpData()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func openShop(_ key: String) {
        AFHandler.shopDetail(key) { shop in
            guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoSummaryViewController.identifier) as? ShopInfoSummaryViewController  else { return }

            vc.modalPresentationStyle = .overFullScreen
            vc.shop = shop
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize(width: 120, height: 32)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShopType.filteredAllCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell
        else { return UICollectionViewCell() }

        let type = ShopType.filteredAllCases[indexPath.row]
        cell.configure(type: type)
        if let isSelected = type2isSelected[indexPath.row] {
            cell.isSelected = isSelected
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let type = ShopType.filteredAllCases.first(where: {
            $0.rawValue == indexPath.row
        }) else { return false }
        
        shownWineShops.removeAll()
        if type == .all {
            if UserData.isConvenienceOn {
                shownWineShops = allOfWineShopsNearBy
            } else {
                shownWineShops = allOfWineShopsNearBy.filter({$0.type != .convenience})
            }
        } else {
            shownWineShops = allOfWineShopsNearBy.filter{ $0.type == type }
        }
        
        type2isSelected.removeAll()
        ShopType.filteredAllCases.forEach {
            type2isSelected[$0.rawValue] = ($0 == type)
        }
         
        self.collectionView.reloadData()
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}

extension MainViewController: CLLocationManagerDelegate {
    private func setUserLocation() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager = locationManager
        
        findCurrentPosition()
    }
    
    private func setLocationManager(_ status : CLAuthorizationStatus) {
        guard let locationManager = self.locationManager else { return }
        switch status {
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse :
            guard let lat = locationManager.location?.coordinate.latitude,
                let lng = locationManager.location?.coordinate.longitude
            else { return }
            DispatchQueue.global().async {
                AFHandler.shopList(lat, lng) {
                    self.allOfWineShopsNearBy.removeAll()
                    self.allOfWineShopsNearBy = $0
                }
            }
            updateFocus(lat, lng)
        default:
            notiUserLocationAuthorized()
        }
        
        setMapView()
    }
    
    //현재 위치 화면 이동
    private func findCurrentPosition() {
        guard let locationManager = locationManager else { return }
        guard CLLocationManager.locationServicesEnabled() else { return }
        let status : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        setLocationManager(status)
    }
    
    //사용자 권한 허용후 처리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setLocationManager(status)
    }
    
    private func notiUserLocationAuthorized() {
        let alert = UIAlertController(title: "위치 권한",
                                      message: "앱 설정화면에서 위치 권한을 허용으로 바꾸어 주세요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default) { _ in
            guard let appSettings = URL(string: UIApplication.openSettingsURLString)
            else { return }
            
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        })
        alert.addAction(UIAlertAction(title: "아니오", style: .destructive))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension MainViewController: NMFMapViewCameraDelegate {
    private func setMapView() {
        nmfNaverMapView.mapView.addCameraDelegate(delegate: self)
        nmfNaverMapView.mapView.positionMode = .direction
        nmfNaverMapView.showZoomControls = true
        nmfNaverMapView.showLocationButton = true
    }
    
    internal func updateFocus(_ lat: Double, _ lng: Double) {
        let camPosition =  NMGLatLng(lat: lat, lng: lng)
        let crntZoomLevel = nmfNaverMapView.mapView.cameraPosition.zoom
        let zoomLevel: Double = crntZoomLevel > 14 ? crntZoomLevel : 14
        let position = NMFCameraPosition(camPosition, zoom: zoomLevel, tilt: 0, heading: 0)
        nmfNaverMapView.mapView.moveCamera(NMFCameraUpdate(position: position))
    }
    
    private func updateMaker() {
        allOfMarkers.forEach { $0.mapView = nil }
        allOfMarkers.removeAll()
        shownWineShops.forEach { shop in
            guard !shop.imgName.isEmpty else { return }
        
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: shop.latitude, lng: shop.longtitude)
            marker.mapView = self.nmfNaverMapView.mapView
            marker.iconImage = NMFOverlayImage(name: shop.imgName)
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                self?.whenBeSelectedMarker(shop)
                return true
            }
            allOfMarkers.append(marker)
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        guard let locationManager = locationManager,
              let lat = locationManager.location?.coordinate.latitude,
              let lng = locationManager.location?.coordinate.longitude
        else { return }
        
        searchBtn.isHidden = (mapView.latitude == lat && mapView.longitude == lng)
    }
}
