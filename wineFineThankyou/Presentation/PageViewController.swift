////
////  PageViewController.swift
////  wineFindThankyou
////
////  Created by betty on 2022/01/17.
////
//
//import Foundation
//import UIKit
//
//class PageViewController: UIPageViewController {
//    private lazy var vcArray: [QAViewController] = {
//        let vcArr = [self.vcInstance(name: "FirstPageVC"),
//                     self.vcInstance(name: "SecondPageVC"),
//                     self.vcInstance(name: "ThirdPageVC")]
//        vcArr.forEach { $0.delegate = self }
//        return vcArr
//    }()
//    
//    private lazy var selectImage : UIImage? = {
//        let img = UIImage(named:"selectedStandard")
//        return img
//    }()
//    
//    private lazy var noselectImage: UIImage? = {
//        let img = UIImage(named:"Quesbutton")
//        return img
//    }()
//    
//    private func vcInstance(name: String) -> QAViewController {
//        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name) as? QAViewController else { return FirstQAViewController() }
//        return vc
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.dataSource = self
//        self.delegate = self
//    
//        if let firstVC = vcArray.first {
//            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//        }
//    }
//}
//
//extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let vcBefore = viewController as? QAViewController,
//                let vcIndex = vcArray.firstIndex(of: vcBefore)
//        else {
//            return nil
//        }
//        
//        let prevIndex = vcIndex - 1
//        guard prevIndex >= 0 else {
//            return nil
//        }
//        
//        guard vcArray.count > prevIndex else {
//            return nil
//        }
//        
//        return vcArray[prevIndex]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let vcAfter = viewController as? QAViewController,
//                let vcIndex = vcArray.firstIndex(of: vcAfter)
//        else {
//            return nil
//            
//        }
//        
//        let nextIndex = vcIndex + 1
//        guard nextIndex < vcArray.count else {
//            return nil
//        }
//        guard vcArray.count > nextIndex else { return nil }
//        
//        return vcArray[nextIndex]
//    }
//}
//
//extension PageViewController: SelectQuestionProtocol{
//    func renewButtons(_ sender: UIButton, btns: [UIButton]) {
//        sender.setBackgroundImage(selectImage, for: .normal)
//        sender.setTitleColor(UIColor.white, for: .normal)
//        btns.filter { !$0.isEqual(sender)}
//            .forEach {
//                $0.setBackgroundImage(noselectImage, for: .normal)
//                $0.setTitleColor(UIColor.black, for: .normal)
//        }
//    }
//}
