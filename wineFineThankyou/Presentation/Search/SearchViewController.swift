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
    @IBOutlet private weak var searchCollectionView: UICollectionView!
    @IBOutlet private weak var searchingTableView: UITableView!
    @IBOutlet private weak var emptySearchHistory: UIView!
    @IBOutlet private weak var searchingView: UIView!
    @IBOutlet private weak var viewLine: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet weak var beforeSearchedTitle: UILabel!
    @IBOutlet private weak var searchingViewTop: NSLayoutConstraint!
    private var searchingShopViewModel: [SearchingShopViewModel] = []
    private var isBeforeSearchedPrint = true
    private var beforeSearched: [String] {
        if isBeforeSearchedPrint {
            return UserData.beforeSearched.components(separatedBy: ",").filter{ !$0.isEmpty }.reversed()
        } else {
            return []
        }
    }
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
        setAdditionalView()
    }
    
    @IBAction func onClickDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupCollectionView()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            self.isBeforeSearchedPrint = true
        } else {
            self.isBeforeSearchedPrint = false
        }
        searchingView.isHidden = false
        searchingViewTop.constant = isBeforeSearchedPrint ? 150 + beforeSearchedTitle.frame.height : 20
        
        getSearchWineShop {
            DispatchQueue.main.async {
                self.searchingTableView.reloadData()
            }
        }
    }
    
    private func getSearchWineShop(done: (() -> Void)?) {
        guard let text = textField.text else { return }
        
        AFHandler.searchShop(byKeyword: text, done: { response in
            self.searchingShopViewModel.removeAll()
            self.searchingShopViewModel.append(contentsOf: response)
            done?()
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
    
    private func setAdditionalView() {
        if beforeSearched.isEmpty {
            emptySearchHistory.isHidden = false
            searchingView.isHidden = true
            searchingViewTop.constant = 20
        } else {
            emptySearchHistory.isHidden = true
            searchingView.isHidden = false
            searchingViewTop.constant = 150 + beforeSearchedTitle.frame.height
            
            self.searchingTableView.reloadData()
        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isBeforeSearchedPrint else {
            return searchingShopViewModel.count
        }
        
        return beforeSearched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingTableViewCell", for: indexPath) as! SearchingTableViewCell
        cell.isDelete = isBeforeSearchedPrint
        guard !isBeforeSearchedPrint else {
            cell.labelText = beforeSearched[indexPath.row]
            cell.closeBtnClosure = {
                DispatchQueue.main.async { tableView.reloadData() }
            }
            return cell
        }
        cell.labelText = searchingShopViewModel[indexPath.row].sh_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingTableViewCell", for: indexPath) as! SearchingTableViewCell
        cell.selectionStyle = .none
        tableView.deselectRow(at: indexPath, animated: false)
        guard !isBeforeSearchedPrint else {
            let searched = beforeSearched[indexPath.row]
            textField.text = searched
            self.textFieldDidChange(textField)
            return
        }
        
        let keyword = searchingShopViewModel[indexPath.row].sh_no
        guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoSummaryViewController.identifier) as? ShopInfoSummaryViewController  else { return }
        
        if let txt = textField.text {
            UserData.beforeSearched = txt
        }
        
        DispatchQueue.main.async {
            AFHandler.shopDetail(keyword) { shop in
                self.dismiss(animated: true) {
                    guard let topVC = topViewController() else { return }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.shop = shop
                    DispatchQueue.main.async {
                        topVC.present(vc, animated: true)
                    }
                }
            }
        }
    }
}


final class SearchingTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var rightBtn: UIButton!
    internal var closeBtnClosure: (() -> Void)?
    internal var isDelete: Bool = false
    internal var labelText: String = "" {
        didSet { configure() }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        guard let titleLabel = titleLabel else { return }
        titleLabel.text = labelText
        imgView.image = UIImage(named: "leftTopArrow")
        imgView.contentMode = .scaleAspectFill
        if isDelete {
            imgView.isHidden = true
            rightBtn.isHidden = false
        } else {
            imgView.isHidden = false
            rightBtn.isHidden = true
        }
    }
    
    @IBAction func rightBtnAction(_ sender: UIButton) {
        let newValues = UserData.beforeSearched.components(separatedBy: ",").filter { $0 != labelText }
        UserData.beforeSearched = "NULL"
        newValues.forEach {
             UserData.beforeSearched = $0
        }
        closeBtnClosure?()
    }
}
