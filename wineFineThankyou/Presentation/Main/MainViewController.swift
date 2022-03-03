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

class MainViewController: UIViewController, NMFMapViewCameraDelegate {
    private let arrCategoryName: [String] = [
            "전체 ",
            "개인샵",
            "체인샵",
            "편의점",
            "대형마트",
            "창고형매장",
            "백화점"
    ]
    //MARK: 마커 표시를 위한 테스트 함수 및 코드입니다.
    let storeLocationList = [
        StoreLocation(id: 0, lat: 37.5670135 , lng: 126.9783740),
        StoreLocation(id: 1, lat: 37.567624752635496, lng: 126.98651057682375)
        
    ]

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: NMFNaverMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButtonOutlet: UIButton!

    var wineInfos: [WineInfo] = []
    var wineStoreInfos: [WineStoreInfo] = []
    var mapAnimatedFlag = false
    var previousOffset: CGFloat = 0
    var markers: [NMFMarker] = []
    let disposeBag = DisposeBag()
    
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Tag")
        button.setImage(image, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCollectionView()
        //MARK: 테스트 데이터
        loadTestDatas()
        //MARK: 마커 표시를 위한 테스트 함수 및 코드입니다.
        testFuncForShowingMarker()
    }
    //MARK: 마커 표시를 위한 테스트 변수
    var locationManager : CLLocationManager?
    
    private func setupUI() {
        
        rightBtn.addTarget(self, action: #selector(openMyPage), for: .touchUpInside)
        
        self.view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.width.equalTo(46)
        }
        makeTestButtonCode()
        self.mapView.bringSubviewToFront(searchView)
        self.mapView.bringSubviewToFront(filterView)
    }
    
    func fetchStoresFromCurrentLocation() {
      LocationManager.shared.getCurrentLocation()
        .subscribe(
          onNext: { [weak self] location in
            guard let self = self else { return }
            let camera = NMFCameraUpdate(scrollTo: NMGLatLng(
              lat: location.coordinate.latitude,
              lng: location.coordinate.longitude
            ))
            camera.animation = .easeIn

//            self.mapView.moveCamera(camera)
          })
        .disposed(by: self.disposeBag)
    }

    
    private func selectMarker(selectedIndex: Int, stores: [Store]) {
      self.clearMarker()
      
      for index in stores.indices {
        let store = stores[index]
        let marker = NMFMarker()
        
        marker.position = NMGLatLng(lat: store.latitude, lng: store.longitude)
        if index == selectedIndex {
          let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(
            lat: store.latitude,
            lng: store.longitude
          ))
          cameraUpdate.animation = .easeIn
//          self.mapView.moveCamera(cameraUpdate)
          marker.iconImage = NMFOverlayImage(name: "Group 34")
          marker.width = 48
          marker.height = 59
        } else {
          marker.iconImage = NMFOverlayImage(name: "Group 32")
          marker.width = 24
          marker.height = 24
        }
//        marker.mapView = self.mapView

        self.markers.append(marker)
      }
    }
    
    private func clearMarker() {
      for marker in self.markers {
        marker.mapView = nil
      }
    }
    
    
    @objc
    private func openMyPage() {
        guard let vc = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil).instantiateViewController(withIdentifier: MyPageViewController.identifier) as? MyPageViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.wineInfos = wineInfos
        vc.visitedWineStoreInfos = wineStoreInfos.deduplicate()
        vc.favoritesWineStoreInfos = wineStoreInfos.deduplicate()
        
        self.present(vc, animated: true)
    }
    
    
    private func makeTestButtonCode() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.mapView.topAnchor, constant: 200),
            button.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 75),
            button.heightAnchor.constraint(equalToConstant: 40),
        ])
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(openStore), for: .touchDown)
    }
  
    @objc
    private func openStore() {
        loadStoreInfoFromServer {
            guard $0 else { return }
            showStoreInfoSummary()
        }
        
        func showStoreInfoSummary() {
            guard let vc = UIStoryboard(name: StoryBoard.store.name, bundle: nil).instantiateViewController(withIdentifier: StoreInfoSummaryViewController.identifier) as? StoreInfoSummaryViewController  else { return }
            
            vc.modalPresentationStyle = .overFullScreen
            
            //MARK: 문용. 테스트.
            let randomKey = (0 ... 9).randomElement()
            vc.wineStoreInfo = wineStoreInfos.filter { $0.key == randomKey }.first
            vc.wineInfos = wineInfos.filter { $0.storeFk == randomKey ?? 0 }
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
       // requestNetworking.dowhat(longitude: 126.8837913, latitude: 37.5848659)
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



final class MainCollectionViewCell: UICollectionViewCell {
    
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = MainCollectionViewCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private let titleLabel: UILabel = UILabel()
    private var titleImage: UIImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupView() {
        backgroundColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(15)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
    }
    
    func configureColor(with color: UIColor) {
        self.backgroundColor = color
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
}

//MARK: TEST DATA
extension MainViewController {
    func loadTestDatas() {
        guard let img = UIImage(named: "TestWineImg") else { return }
        (0 ... 9).forEach {
            let type = StoreType.allCases.randomElement() ?? .privateShop
            let wineStoreInfo = WineStoreInfo(key: $0,
                                              storeName: "\($0)+벵가드와인머천트 분당지점",
                                              classification: type,
                                              callNumber: "010-1111-2222",
                                              location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                              openingHours: "AM07:00 - PM11:00",
                                              homepage: "https://wineFindThankYou.kr")
            
            let wineInfo = WineInfo(img: img,
                                    korName: "비카스 초이스 소비뇽 블랑 스파클링",
                                    engName: "Vicar's Choice Sauvignon Blanc Bubbles",
                                    wineType: WineType.sparkling,
                                    cepage: "소비뇽 블랑 (Sauvignon Blanc)",
                                    from: "뉴질랜드",
                                    vintage: "2010",
                                    alchol: "Alc. 15%", storeFk: wineStoreInfo.key, boughtDate: Date())
            let wineInfo2 = WineInfo(img: img,
                                     korName: "젠틀 타이거 화이트",
                                     engName: "Gentle Tiger White",
                                     wineType: WineType.white,
                                     cepage: "샤르도네 (Chardonnay), 비우라 (Viura)",
                                     from: "뉴질랜드",
                                     vintage: "2010",
                                     alchol: "Alc. 15%", storeFk: wineStoreInfo.key, boughtDate: Date(timeInterval: TimeInterval(-86400 * $0), since: Date()))
            let wineInfo3 = WineInfo(img: img,
                                     korName: "카피텔 산 로코 발폴리첼라 리파쏘 수페리오레",
                                     engName: "Capitel San Rocco Valpolicella Ripasso Superiore",
                                     wineType: WineType.red,
                                     cepage: "코르비나(Corvina), 코르비노네(Corvinone), 론디넬라(Rondinella), 기타(Others)",
                                     from: "아르헨티나",
                                     vintage: "2010",
                                     alchol: "Alc. 15%", storeFk: wineStoreInfo.key, boughtDate: Date(timeInterval: TimeInterval(-86400 * 10 - $0), since: Date()))
            let wineInfo4 = WineInfo(img: img,
                                     korName: "젠틀 타이거 레드",
                                     engName: "Gentle Tiger Red",
                                     wineType: WineType.red,
                                     cepage: "샤르도네 (Chardonnay)",
                                     from: "뉴질랜드",
                                     vintage: "2010",
                                     alchol: "Alc. 13%", storeFk: wineStoreInfo.key, boughtDate: Date(timeInterval: TimeInterval(-86400 * 7 - $0), since: Date()))
            
            if $0 % 5 == 0 {
                self.wineInfos.append(wineInfo)
            }
            self.wineInfos.append(wineInfo2)
            if $0 % 2 == 0 {
                self.wineInfos.append(wineInfo3)
                self.wineInfos.append(wineInfo4)
            }
            self.wineStoreInfos.append(wineStoreInfo)
        }
    }
}

extension Array where Element == WineStoreInfo {
    func deduplicate() -> [Element] {
        var deduplicated = [WineStoreInfo]()
        self.forEach { wineStoreInfo in
            guard !deduplicated.contains(where: {$0.key == wineStoreInfo.key})
            else { return }
            deduplicated.append(wineStoreInfo)
        }
        return deduplicated
    }
}

//MARK: !!!!! 마커 표시를 위한 테스트 함수 및 코드입니다.
// 적절히 수정하여 사용하시면 될 듯 합니다.
extension MainViewController: CLLocationManagerDelegate {
    struct StoreLocation {
        let id : Int
        let lat, lng: Double
    }
    
    func testFuncForShowingMarker() {
        setLocation()
    }
    
    private func setLocation() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //배터리 상태에 따른 최적의 정확도 표시를 위해 설정.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager = locationManager
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
        processLocation(status)
    }
    
    //사용자 권한 허용후 처리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization")
        processLocation(status)
    }
    
    private func updateFocus(lat : CLLocationDegrees, lng : CLLocationDegrees) {
        let camPosition =  NMGLatLng(lat: lat, lng: lng)
        let position = NMFCameraPosition(camPosition, zoom: 14, tilt: 0, heading: 0)
        mapView.mapView.moveCamera(NMFCameraUpdate(position: position))
    }
    
    private func showStoreInfo(_ index : Int) {
        print("\(storeLocationList[index])")
    }
    
    //MARK: 표시하기 위한 마커 업데이트 함수.
    private func updateMaker(_ stationList : [StoreLocation]) {
        for item in stationList {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: item.lat, lng: item.lng)
            marker.mapView = self.mapView.mapView
            marker.iconImage = NMFOverlayImage(name: "Group 32")
            marker.userInfo = ["tag" : item.id, "lat" : Double(item.lat), "long" : Double(item.lng)]
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let index = overlay.userInfo["tag"] as? Int,
                      let lat = overlay.userInfo["lat"] as? Double,
                      let long = overlay.userInfo["long"] as? Double
                else { return false}
                
                print("\(index): 마커 터치됨")
                self?.updateFocus(lat: lat, lng: long)
                self?.showStoreInfo(index)
                return true
            }
        }
    }
    
    func processLocation(_ status : CLAuthorizationStatus) {
        guard let locationManager = self.locationManager else { return }
        switch status {
        case .restricted, .denied:
            print("유저가 설정에서 기기 위치 설정을 OFF.")
            print("유저가 이 앱이 기기 위치정보에 접근하는 것을 거부")
        case .notDetermined :
            print("물어봐야 함")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse :
            guard let lat = locationManager.location?.coordinate.latitude,
                let lng = locationManager.location?.coordinate.longitude else {
                return
            }
            updateFocus(lat: lat, lng: lng)
            mapView.mapView.positionMode = .direction
            self.updateMaker(self.storeLocationList)
        default:
            return
        }
    }
}
