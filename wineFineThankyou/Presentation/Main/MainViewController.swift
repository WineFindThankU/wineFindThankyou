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
        rightBtn.addTarget(self, action: #selector(openMyPage), for: .touchUpInside)
    }
    
    @objc
    private func openMyPage() {
        guard let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else { return }
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    private func openStore() {
        loadStoreInfoFromServer {
            guard $0 else { return }
            showStoreInfoSummary()
        }
        
        func showStoreInfoSummary() {
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
        
        // MARK: 이부분... 더 효율적으로 짜겠습니다.
        if titleLabel.text == "전체" {
            titleLabel.textColor = .black
        } else if titleLabel.text == "개인샵" {
            titleLabel.textColor = UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
        } else if titleLabel.text == "체인샵" {
            titleLabel.textColor = UIColor(red: 253.0, green: 139.0, blue: 188.0, alpha: 1.0)
        } else if titleLabel.text == "편의점" {
            titleLabel.textColor = UIColor(red: 246.0, green: 195.0, blue: 49.0, alpha: 1.0)
        } else if titleLabel.text == "대형마트" {
            titleLabel.textColor = UIColor(red: 252.0, green: 145.0, blue: 51.0, alpha: 1.0)
        } else if titleLabel.text == "창고형 매장" {
            titleLabel.textColor = UIColor(red: 242.0, green: 44.0, blue: 62.0, alpha: 1.0)
        } else if titleLabel.text == "백화점" {
            titleLabel.textColor = UIColor(red: 61.0, green: 183.0, blue: 229.0, alpha: 1.0)
        }
    }
    
    // MARK: 이부분... 더 효율적으로 짜겠습니다.
    override var isSelected: Bool {
            didSet{
                if isSelected {
                    titleLabel.textColor = .white
                    
                    if titleLabel.text == "전체" {
                        titleLabel.backgroundColor = .black
                    } else if titleLabel.text == "개인샵" {
                        titleLabel.backgroundColor = UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
                    }
                    
                }
                else {
                    titleLabel.backgroundColor = .clear
                }
            }
        }
    
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
}
