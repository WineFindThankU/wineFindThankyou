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

protocol SearchingShopDisplayLogic: AnyObject
{
    func displaySearchProduct(viewModel: SearchingShopViewModel)
}


class SearchViewController: UIViewController {
    
    var responseDataCount = 0
    var shop: Shop?
    
    var searchingShopViewModel: [SearchingShopViewModel] = []
    
    private weak var topView: TopView?
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var searchingTableView: UITableView!
    
    @IBOutlet weak var emptySearchHistory: UIView!
    
    @IBOutlet weak var searchingView: UIView!
    
    @IBOutlet weak var viewLine: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    private let items: [String] = [
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
        if textField.text?.count ?? 0 >= 2 {
            AFHandler.searchShop(byKeyword: textField.text ?? "", done: { response in
                self.searchingShopViewModel.removeAll()
                self.searchingShopViewModel.append(contentsOf: response)
                DispatchQueue.main.async {
                    self.searchingTableView.reloadData()
                }
            })
        }
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
        return items.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(name: items[indexPath.item])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SearchCollectionViewCell.fittingSize(availableHeight: 32, name: items[indexPath.item])
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
        let searhingShop_ViewModel = searchingShopViewModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingTableViewCell", for: indexPath) as! SearchingTableViewCell
        cell.searhingShopViewModel = searchingShopViewModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingTableViewCell", for: indexPath) as! SearchingTableViewCell
        cell.selectionStyle = .none
        tableView.deselectRow(at: indexPath, animated: false)
        print("======> \(indexPath.row)")
        let keyword = searchingShopViewModel[indexPath.row].sh_no
        MainViewController().openShop(keyword)
    }
}


final class SearchingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: Shop? = nil
    var searhingShopViewModel: SearchingShopViewModel? = nil {
        didSet {
            configureSetting()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
        
    func initSetting(name: String, number: String) {
        titleLabel.text = name
    }
    
    func configureSetting() {
        titleLabel.text = searhingShopViewModel?.sh_name
    }

}



extension SearchViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doSearchShop()
        return true
    }
    
    func doSearchShop() {
        let text = textField.text ?? ""
        AFHandler.searchShop(byKeyword: text, done: { _ in
            DispatchQueue.main.async {
                self.searchingTableView.reloadData()
            }
        })
    }
    
}
