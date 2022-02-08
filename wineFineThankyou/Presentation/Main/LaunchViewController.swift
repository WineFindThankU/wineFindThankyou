//
//  LaunchViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit
class LaunchViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfigure()
        
        /*
         animateAndGoTo { [weak self] isLogIn in
         guard isLogIn else { self?.goToQuestionVC(); return }
         
         self?.loadUserDataFromServer { isSuccess in
             isSuccess ? self?.goToMain() : self?.showAlert()
            }
         }
         
         */
    
    }
    
    private func goToMain()  {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartViewController") as? StartViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "인터넷 연결 오류",
                                      message: "유저 데이터를 받아오는데, 실패하였습니다.\n인터넷 연결을 확인하고 다시 시도해주세요.",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel){ _ in
            alert.dismiss(animated: true) {
                self.loadUserDataFromServer { isSuccess in
                    isSuccess ? self.goToMain() : self.showAlert()
                }
            }
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func goToQuestionVC() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainQAViewController") as? MainQAViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
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
    
    private func loadUserDataFromServer(downDone: ((Bool) -> Void)?) {
        // MARK: 서버로부터 유저 데이터 받아오는 곳.
        downDone?(true)
    }
    
    
    @IBAction func onClickStartButton(_ sender: Any) {
        goToQuestionVC()
    }
    
    
}
