//
//  LaunchViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit
class LaunchViewController: UIViewController{
    enum VcType {
        case question
        case main
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfigure()
        animateAndGoTo { isLogIn in
            self.goToNextVc(isLogIn ? .main: .question)
        }
    }
    
    private func goToNextVc(_ type: VcType) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch type {
        case .main:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            else { return }
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: true)
                return
            }
        case .question:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "MainQAViewController") as? MainQAViewController
            else { return }
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: true)
                return
            }
        }
    }
    
    private func initConfigure() {
        self.view.backgroundColor = Theme.purple.color
    }
    
    private func animateAndGoTo(done: ((Bool) -> Void)?) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.77, delay: 0, animations: {
            self.view.backgroundColor = Theme.white.color
        }, completion: { _ in
            done?(UserData.isUserLogin)
        })
    }
}
