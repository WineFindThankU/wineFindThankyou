//
//  PageViewController.swift
//  wineFindThankyou
//
//  Created by betty on 2022/01/17.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {

    
    lazy var vcArray: [UIViewController] = {
        return [self.vcInstance(name: "FirstPageVC"),
                self.vcInstance(name: "SecondPageVC"),
                self.vcInstance(name: "ThirdPageVC")]
    }()
    private func vcInstance(name: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
  
    }
    


}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // 이전 페이지로 넘기는 부분
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController) else {
            return nil
        }
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0 else {
            return nil
        }
        
        guard vcArray.count > prevIndex else {
            return nil
        }
        return vcArray[prevIndex]
    }
    
    
    // 다음 페이지로 넘기는 부분
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController) else {
            return nil
            
        }
        let nextIndex = vcIndex + 1
        guard nextIndex < vcArray.count else {
            return nil
        }
        guard vcArray.count > nextIndex else { return nil }
        return vcArray[nextIndex]
    }
    
}
