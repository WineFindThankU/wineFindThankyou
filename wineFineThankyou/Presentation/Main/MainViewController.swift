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

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    var wineStoreInfo: WineStoreInfo?
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
        self.setMap()
        
        // TEST
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = mapView
        marker.iconImage = NMFOverlayImage(name: "Group 32")
    }
    
    private func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        rightBtn.addTarget(self, action: #selector(openMyPage), for: .touchUpInside)
        
        self.view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.width.equalTo(46)
        }
        makeTestButtonCode()
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

            self.mapView.moveCamera(camera)
          })
        .disposed(by: self.disposeBag)
    }
    
    private func setMap() {
        mapView.positionMode = .direction
        mapView.zoomLevel = 15
        mapView.addCameraDelegate(delegate: self)
        
    }
    
    fileprivate func moveCamera(position: CLLocation) {
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(
                lat: position.coordinate.latitude,
                lng: position.coordinate.longitude
            ),
            zoom: self.mapView.zoomLevel
        )
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        
        cameraUpdate.animation = .easeIn
        self.mapView.moveCamera(cameraUpdate)
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
          self.mapView.moveCamera(cameraUpdate)
          marker.iconImage = NMFOverlayImage(name: "Group 34")
          marker.width = 48
          marker.height = 59
        } else {
          marker.iconImage = NMFOverlayImage(name: "Group 32")
          marker.width = 24
          marker.height = 24
        }
        marker.mapView = self.mapView

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
        requestNetworking.getShopsList(longitude: 126.8837913, latitude: 37.5848659)
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
        cell.configure(name: arrCategoryName[indexPath.item])
        cell.configureColor(with: color)
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
