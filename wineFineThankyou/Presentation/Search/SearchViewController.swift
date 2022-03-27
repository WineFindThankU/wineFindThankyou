//
//  SearchViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/29.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

struct SearchingShopViewModel {
    var sh_no: String
    var sh_name: String
}

protocol SearchingShopDisplayLogic: AnyObject {
    func displaySearchProduct(viewModel: SearchingShopViewModel)
}

class SearchViewController: UIViewController {
    var shop: Shop?
    var searchingShopViewModel: [SearchingShopViewModel] = []
    private weak var topView: TopView?
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchingTableView: UITableView!
    @IBOutlet weak var emptySearchHistory: UIView!
    @IBOutlet weak var searchingView: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var textField: UITextField!
    
    private let shopNames: [String] = [
            "서현동",
            "행정동",
            "법정동",
            "이매동"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    @IBAction func onClickDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        emptySearchHistory.isHidden = false
        searchingView.isHidden = true
        setupCollectionView()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchingView.isHidden = false
        DispatchQueue.main.async {
            self.searchingTableView.reloadData()
        }
        getSearchWineShop()
    }
    
    private func getSearchWineShop() {
        guard let text = textField.text else { return }
        
        AFHandler.searchShop(byKeyword: text, done: { response in
            self.searchingShopViewModel.removeAll()
            self.searchingShopViewModel.append(contentsOf: response)
            DispatchQueue.main.async {
                self.searchingTableView.reloadData()
            }
        })
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.scrollDirection = .horizontal
        searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .white
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
    }
    
    private func setupTableView() {
        searchingTableView.delegate = self
        searchingTableView.dataSource = self
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopNames.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(name: shopNames[indexPath.item])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SearchCollectionViewCell.fittingSize(availableHeight: 32, name: shopNames[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopName = shopNames[indexPath.row]
        textField.text = shopName
        self.textFieldDidChange(textField)
    }
}

final class SearchCollectionViewCell: UICollectionViewCell {
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = SearchCollectionViewCell()
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
        titleLabel.textColor = .black
        titleLabel.font = titleLabel.font.withSize(15)
       
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingShopViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingTableViewCell", for: indexPath) as! SearchingTableViewCell
        cell.searhingShopViewModel = searchingShopViewModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingTableViewCell", for: indexPath) as! SearchingTableViewCell
        cell.selectionStyle = .none
        tableView.deselectRow(at: indexPath, animated: false)
        let keyword = searchingShopViewModel[indexPath.row].sh_no
        guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoSummaryViewController.identifier) as? ShopInfoSummaryViewController  else { return }
        
        DispatchQueue.main.async {
            AFHandler.shopDetail(keyword) { shop in
                self.dismiss(animated: true) {
                    guard let topVC = topViewController() else { return }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.shop = shop
                    DispatchQueue.main.async { [weak self] in
                        topVC.present(vc, animated: true)
                    }
                }
            }
        }
    }
}


final class SearchingTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    var searhingShopViewModel: SearchingShopViewModel? = nil {
        didSet {
            guard titleLabel != nil else { return }
            configureSetting()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureSetting() {
        titleLabel.text = searhingShopViewModel?.sh_name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel = .none
    }
}
