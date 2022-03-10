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
    private var wineInfos: [WineInfo] = []
    
    //근처의 모든 와인샵
    private var allOfWineShopsNearBy: [Shop] = [] {
        didSet { self.shownWineShops = allOfWineShopsNearBy }
    }
    
    private var shownWineShops: [Shop] = [] {
        didSet { updateMaker() }
    }
    
    private let nameArr = ShopType.allCases.compactMap { $0.str }
    private var cellDic = [Int: MainCollectionViewCell]()
    private var allOfMarkers = [NMFMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserLocation()
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
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
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
        vc.wineInfos = wineInfos
        
        self.present(vc, animated: true)
    }
    
    @objc
    func showShopsAtCrntLoc() {
        let crntLoc = self.nmfNaverMapView.mapView.cameraPosition.target
        DispatchQueue.global().async {
            AFHandler.shopList(crntLoc.lat, crntLoc.lng) {
                self.allOfWineShopsNearBy.removeAll()
                self.allOfWineShopsNearBy = $0
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc
    private func openShop(_ key: String) {
        AFHandler.shopDetail(key) { shop in
            showShopInfoSummary(shop)
        }

        func showShopInfoSummary(_ shopInfo: Shop?) {
            guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoSummaryViewController.identifier) as? ShopInfoSummaryViewController  else { return }

            vc.modalPresentationStyle = .overFullScreen
            vc.shop = shopInfo
            //MARK: 문용. 테스트.
            vc.wineInfos = wineInfos.filter { $0.shopFk == shopInfo?.key }
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}

        let type = ShopType.allCases[indexPath.row]
        cell.configure(type: type)
        cellDic[indexPath.row] = cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let type = ShopType.allCases.first(where: { $0.rawValue == indexPath.row})
        else { return true }
        shownWineShops.removeAll()
        shownWineShops = allOfWineShopsNearBy.filter{ $0.categoryType == type }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 3 - 1.0
        return CGSize(width: width, height: width)
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
            else { break }
            
            DispatchQueue.global().async {
                AFHandler.shopList(lat, lng) {
                    self.allOfWineShopsNearBy.removeAll()
                    self.allOfWineShopsNearBy = $0
                }
            }
            
            updateFocus(lat: lat, lng: lng)
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
    
    private func updateFocus(lat : CLLocationDegrees, lng : CLLocationDegrees) {
        let camPosition =  NMGLatLng(lat: lat, lng: lng)
        let position = NMFCameraPosition(camPosition, zoom: 14, tilt: 0, heading: 0)
        nmfNaverMapView.mapView.moveCamera(NMFCameraUpdate(position: position))
    }
    
    private func updateMaker() {
        allOfMarkers.forEach {
            $0.mapView = nil
        }
        allOfMarkers.removeAll()
        
        let shopsLocation = shownWineShops.compactMap { (key: $0.key, lat: $0.latitude, lng: $0.longtitude)}
        shopsLocation.forEach {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: $0.lat, lng: $0.lng)
            marker.mapView = self.nmfNaverMapView.mapView
            marker.iconImage = NMFOverlayImage(name: "Group 32")
            marker.userInfo = ["key" : $0.key, "lat" : Double($0.lat), "long" : Double($0.lng)]
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let key = overlay.userInfo["key"] as? String,
                      let lat = overlay.userInfo["lat"] as? Double,
                      let long = overlay.userInfo["long"] as? Double
                else { return false }

                self?.updateFocus(lat: lat, lng: long)
                self?.openShop(key)
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
