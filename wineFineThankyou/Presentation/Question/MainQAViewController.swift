//
//  MainQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/18.
//

import UIKit

class MainQAViewController: UIViewController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = 0
        backButton.isHidden = true
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        if pageControl.currentPage == 0 {
            return
        }
    }
   
    @IBAction func onClickback(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        //MARK: 문용 For Test
        if currentPage == 2 {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
        //...
        }
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        backButton.isHidden = pageControl.currentPage == 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
    
}

