//
//  StoreWinesViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

class StoreWinesViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var topView: TopView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var wineTypeLabel: UILabel!
    @IBOutlet private weak var wineDetailsView: WineDetailsView!
    private weak var crntIndexLabel : UILabel!
    
    var crntIndex: Int = 0
    var wines = [WineInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    override func viewDidAppear(_ animated: Bool) {
        wineDetailsView.wineDetail = wines[pageControl.currentPage]
    }
    
    private func configure() {
        pageControl.numberOfPages = wines.count
        pageControl.currentPage = crntIndex
        
        self.view.backgroundColor = Theme.black.color.withAlphaComponent(0.8)
        loadTopView()
        setScrollView()
        
        let wine = wines[pageControl.currentPage]
        wineTypeLabel.text = wine.wineType.str
        wineTypeLabel.textColor = Theme.white.color
        wineTypeLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        wineTypeLabel.backgroundColor = wine.wineType.color
        wineTypeLabel.clipsToBounds = true
        wineTypeLabel.layer.cornerRadius = 7
    }
    
    private func loadTopView() {
        topView = setTopView(self.view, height: 44)
        topView.backgroundColor = .clear
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow")?.withTintColor(.white), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let crntIndexLabel = UILabel()
        topView.addSubview(crntIndexLabel)
        crntIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        crntIndexLabel.textColor = Theme.white.color
        crntIndexLabel.text = "\(pageControl.currentPage + 1) / \(wines.count)"
        crntIndexLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        NSLayoutConstraint.activate([
            crntIndexLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -18),
            crntIndexLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
        ])
        self.crntIndexLabel = crntIndexLabel
    }
    
    private func setScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        for i in 0 ..< wines.count {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            self.scrollView.addSubview(backgroundView)
            let xPosition = (self.view.frame.width) * CGFloat(i)
            backgroundView.frame = CGRect(x: xPosition, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.contentSize.width = backgroundView.frame.width * CGFloat(i + 1)
            
            let crntImgView = UIImageView()
            backgroundView.addSubview(crntImgView)
            crntImgView.image = wines[i].img
            crntImgView.contentMode = .scaleAspectFit //  사진의 비율을 맞춤.
            crntImgView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                crntImgView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                crntImgView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
                crntImgView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                crntImgView.widthAnchor.constraint(equalToConstant: 300),
            ])
        }
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / self.view.frame.width)
        pageControl.currentPage = Int(CGFloat(currentPage))
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func updateUI() {
        let wine = wines[pageControl.currentPage]
        wineTypeLabel.text = wine.wineType.str
        wineTypeLabel.backgroundColor = wine.wineType.color
        crntIndexLabel.text = "\(pageControl.currentPage + 1) / \(wines.count)"
    }
}

