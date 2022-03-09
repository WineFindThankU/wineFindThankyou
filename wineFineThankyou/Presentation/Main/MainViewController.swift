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
    private let arrCategoryName: [String] = [
            "전체 ",
            "개인샵",
            "체인샵",
            "편의점",
            "대형마트",
            "창고형매장",
            "백화점"
    ]

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nmfNaverMapView: NMFNaverMapView!
    @IBOutlet weak var searchView: UIView!
    private unowned var searchBtn: UIButton!
    private var locationManager : CLLocationManager?
    private var wineInfos: [WineInfo] = []
    private var nearWineShops: [ShopInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateMaker()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserLocation()
        self.setupUI()
        
        //MARK: 테스트 데이터
        self.wineInfos = loadTestDatas()
    }
    
    private func setupUI() {
        rightBtn.addTarget(self, action: #selector(openMyPage), for: .touchUpInside)
        makeSeachBtnUsingCrntLoc()
        self.nmfNaverMapView.bringSubviewToFront(searchView)
        self.nmfNaverMapView.bringSubviewToFront(filterView)
    }
    
    @objc
    private func openMyPage() {
        guard let vc = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil).instantiateViewController(withIdentifier: MyPageViewController.identifier) as? MyPageViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.wineInfos = wineInfos
        
        self.present(vc, animated: true)
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
    
    @objc func showShopsAtCrntLoc() {
        let crntLoc = self.nmfNaverMapView.mapView.cameraPosition.target
        DispatchQueue.global().async {
            AFHandler.shopList(crntLoc.lat, crntLoc.lng) {
                self.nearWineShops.removeAll()
                self.nearWineShops = $0
            }
        }
    }
    
    @objc
    private func openStore(_ key: String) {
        AFHandler.shopDetail(key) { shopInfo in
            showStoreInfoSummary(shopInfo)
        }

        func showStoreInfoSummary(_ shopInfo: ShopInfo?) {
            guard let vc = UIStoryboard(name: StoryBoard.store.name, bundle: nil).instantiateViewController(withIdentifier: StoreInfoSummaryViewController.identifier) as? StoreInfoSummaryViewController  else { return }

            vc.modalPresentationStyle = .overFullScreen
            vc.shopInfo = shopInfo
            //MARK: 문용. 테스트.
            vc.wineInfos = wineInfos.filter { $0.storeFk == 0 }
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func onClickSearchBar(_ sender: UIButton) {
        print(sender)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
         vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategoryName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(name: arrCategoryName[indexPath.item])
        return cell
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
    
    func setLocationManager(_ status : CLAuthorizationStatus) {
        guard let locationManager = self.locationManager else { return }
        switch status {
        case .restricted, .denied:
            requestUserLocation()
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse :
            guard let lat = locationManager.location?.coordinate.latitude,
                let lng = locationManager.location?.coordinate.longitude else {
                break
            }
            
            DispatchQueue.global().async {
                AFHandler.shopList(lat, lng) {
                    self.nearWineShops.removeAll()
                    self.nearWineShops = $0
                }
            }
            
            updateFocus(lat: lat, lng: lng)
        default:
            break
        }
        
        setMapView()
    }
    
    //현재 위치 화면 이동
    func findCurrentPosition() {
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
    
    func requestUserLocation() {
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
    
    //MARK: 표시하기 위한 마커 업데이트 함수.
    private func updateMaker() {
        let shopsLocation = nearWineShops.compactMap { (key: $0.key, lat: $0.latitude, lng: $0.longtitude)}
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
                self?.openStore(key)
                return true
            }
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
