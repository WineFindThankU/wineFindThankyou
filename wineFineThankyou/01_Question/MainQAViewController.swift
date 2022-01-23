//
//  MainQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/18.
//

import UIKit

class MainQAViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
  
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
    }
    
    @IBAction func onClickback(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
      
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
    
}

