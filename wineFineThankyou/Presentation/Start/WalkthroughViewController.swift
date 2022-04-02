//
//  WalkthroughViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/04/02.
//

import Foundation
import UIKit

protocol AfterWalkthroughAnswer: AnyObject {
    func selected(_ idx: Int, _ str: String?)
}

class WalkthroughViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func leftArrowAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private var question2Answer = [Int: String]()
    private var pageIdx2Xpos = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        addContentsToScrollView()
        setPageControl()
    }
    
    private func addContentsToScrollView() {
        QuestionList.allCases.enumerated().forEach { idx, question in
            let walkthroughView = WalkthroughView()
            let xPos = self.view.frame.width * CGFloat(idx)
            walkthroughView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(walkthroughView)
            scrollView.contentSize.width = walkthroughView.frame.width * CGFloat(idx + 1)
            walkthroughView.questionNumber = question.rawValue
            walkthroughView.delegate = self
            walkthroughView.nextBtnClosure = {
                guard let xPos = self.pageIdx2Xpos[idx + 1]
                else {
                    
                    // 3번째 화면 결과 화면으로 보내기
                    return
                }
                
                self.scrollView.setContentOffset(CGPoint(x: xPos, y: 0), animated: true)
            }
            pageIdx2Xpos[question.rawValue] = xPos
        }
    }
    
    private func setPageControl() {
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray30
        pageControl.preferredIndicatorImage = UIImage(named: "_page_control")
        pageControl.numberOfPages = QuestionList.allCases.count
    }
}

extension WalkthroughViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlWhenBeSelectedPage(currentPage: Int(round(value)))
    }
    
    private func setPageControlWhenBeSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
}

extension WalkthroughViewController: AfterWalkthroughAnswer{
    func selected(_ idx: Int, _ str: String?) {
        self.question2Answer[idx] = str
    }
}
