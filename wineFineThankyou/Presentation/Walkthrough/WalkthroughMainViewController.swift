//
//  WalkthroughMainViewController.swift
//
//  Created by suding on 2022/03/01.
//

import Foundation
import SnapKit
import UIKit

public class Storage {
   static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
    }
}


final class WalkthroughMainViewController: UIViewController {
    private var currentIndex = 0
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        return pageViewController
    }()
    
    lazy var vc1: UIViewController = {
        let viewController = WalkthroughFirstViewController()
        return viewController
    }()

    lazy var vc2: UIViewController = {
        let viewController = WalkthroughSecondViewController()
        return viewController
    }()

    lazy var vc3: UIViewController = {
        let viewController = WalkthroughThirdViewController()
        return viewController
    }()
    
    lazy var dataViewControllers: [UIViewController] = {
        return [vc1, vc2, vc3]
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let image = UIImage(named: "_question_n")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        let image = UIImage(named: "arrow-left")
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray30
        pageControl.preferredIndicatorImage = UIImage(named: "_page_control")
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        let action = UIAction(handler: { _ in
        })
        pageControl.addAction(action, for: .valueChanged)
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupConfigure()
        setupUI()
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        }
    }

    private func setupDelegate() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .white
        pageControl.currentPage = currentIndex
        
        navigationView.snp.makeConstraints { make in
            make.width.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(22)
        }
     
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(78)
        }
        pageViewController.didMove(toParent: self)
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.height.width.equalTo(69)
        }
    }
    
    private func setupConfigure() {
        view.addSubview(navigationView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
    }
}

extension WalkthroughMainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController)
    -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        currentIndex = previousIndex
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
}

extension WalkthroughMainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController)
    -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        currentIndex = nextIndex
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
       guard completed,
         let currentVC = pageViewController.viewControllers?.first,
         let index = dataViewControllers.firstIndex(of: currentVC) else { return }
         pageControl.currentPage = index
        
        if index == 2 {
            let image = UIImage(named: "_question_s")
            nextButton.setImage(image, for: .normal)
            nextButton.imageView?.contentMode = .scaleAspectFit
            nextButton.contentHorizontalAlignment = .center
            nextButton.semanticContentAttribute = .forceLeftToRight
            let action = UIAction(handler: { _ in
                let nextVC = WalkthroughFourthViewController()
                nextVC.modalPresentationStyle = .overFullScreen
                self.present(nextVC, animated: false)
            })
            nextButton.addAction(action, for: .touchUpInside)
        }
     }
}
