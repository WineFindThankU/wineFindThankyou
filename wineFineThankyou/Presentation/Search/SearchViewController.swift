//
//  SearchViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/29.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private weak var topView: TopView?
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var emptySearchHistory: UIView!
    
    @IBOutlet weak var viewLine: UIView!
    
    // 일단 하드코딩 (API 안됨ㅠ)
    private let items: [String] = [
            "서현동",
            "행정동",
            "법정동",
            "이매동"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func onClickDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    
    private func setupView() {
        view.backgroundColor = .white
        viewLine.backgroundColor = UIColor(red: 245.0, green: 245.0, blue: 245.0, alpha: 1.0)
        emptySearchHistory.isHidden = false
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.scrollDirection = .horizontal
       // flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 12)
        searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .white
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
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
