//
//  StoreWinesViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

class StoreWinesViewController: UIViewController {
    @IBOutlet private weak var topView: TopView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var wineTypeLabel: TagLabel!
    private unowned var wineInfoView: WineInfoView!
    
    private weak var crntIndexLabel : UILabel!
    private let cellSize = CGSize(width: 312, height: 312)
    private var minItemSpacing: CGFloat = 11
    private var previousIndex = 0
    
    internal var crntIndex: Int = 0
    internal var wineInfos = [WineInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopView()
        setupCollectionView()
        setUpWineInfoView()
        setUpWineTypeLabel()
        detailConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func detailConfigure() {
        self.view.backgroundColor = Theme.black.color.withAlphaComponent(0.8)
        self.updateUI()
    }
    
    private func setUpWineTypeLabel(){
        let wine = wineInfos[crntIndex]
        wineTypeLabel.textColor = Theme.white.color
        wineTypeLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        wineTypeLabel.text = wine.wineType.str
        wineTypeLabel.backgroundColor = wine.wineType.color
        wineTypeLabel.clipsToBounds = true
        wineTypeLabel.layer.cornerRadius = 7
        self.view.bringSubviewToFront(wineTypeLabel)
    }
    
    private func setUpTopView() {
        topView = getGlobalTopView(self.view, height: 44)
        topView.backgroundColor = .clear
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow")?.withTintColor(.white), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let crntIndexLabel = UILabel()
        self.topView.addSubview(crntIndexLabel)
        crntIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        crntIndexLabel.textColor = Theme.white.color
        crntIndexLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        NSLayoutConstraint.activate([
            crntIndexLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -18),
            crntIndexLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
        ])
        self.crntIndexLabel = crntIndexLabel
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        let cellWidth: CGFloat = floor(cellSize.width)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "WineImageCell", bundle: nil), forCellWithReuseIdentifier: "WineImageCell")
        collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.scrollToItem(at: IndexPath(row: self.crntIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func setUpWineInfoView() {
        let wineInfoView = WineInfoView()
        self.view.addSubview(wineInfoView)
        wineInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wineInfoView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 20),
            wineInfoView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            wineInfoView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            wineInfoView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        wineInfoView.backgroundColor = .clear
        self.wineInfoView = wineInfoView
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension StoreWinesViewController {
    private func updateUI(){
        self.crntIndexLabel.text = "\(self.crntIndex + 1) / \(wineInfos.count)"
        self.wineInfoView.wineInfo = wineInfos[self.crntIndex]
        wineTypeLabel.text = wineInfos[self.crntIndex].wineType.str
        wineTypeLabel.backgroundColor = wineInfos[self.crntIndex].wineType.color
    }
}

extension StoreWinesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wineInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineImageCell", for: indexPath) as? WineImageCell else { return UICollectionViewCell() }
        cell.wineImage.image = wineInfos[indexPath.row].img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minItemSpacing
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthWithSpacing = cellSize.width + minItemSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthWithSpacing
        let roundedIndex: CGFloat = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthWithSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        self.crntIndex = Int(roundedIndex)
        self.updateUI()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidthWithSpacing = cellSize.width + minItemSpacing
        let offsetX = collectionView.contentOffset.x
        let index = (offsetX + collectionView.contentInset.left) / cellWidthWithSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) {
            animateZoom(cell)
        }
        if Int(roundedIndex) != previousIndex {
            let preIndexPath = IndexPath(item: previousIndex, section: 0)
            if let preCell = collectionView.cellForItem(at: preIndexPath) { animateRemove(preCell)
            }
            previousIndex = indexPath.item
        }
    }
    
    private func animateZoom(_ cell: UICollectionViewCell) {
        UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
    
    private func animateRemove(_ cell: UICollectionViewCell) {
        UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: nil)
    }
}
