//
//  StartViewController.swift
//  wineFindThankyou
//
//  Created by betty on 2022/02/04.
//

import UIKit
import Lottie
import SnapKit

class StartViewController: UIViewController {
    lazy var lottieAnimationView: AnimationView = {
        let animationView = AnimationView()
        animationView.animation = Animation.named("WinefindThankU_motion_eyes")
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        return animationView
    }()
    
    lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchTitle")
        return imageView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = .standardColor
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let action = UIAction(handler: { _ in
            let view = WalkthroughMainViewController()
            view.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self.present(view, animated: true)
            }
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        determineNextStep()
    }
    
    private func setupUI() {
        self.view.addSubview(titleImageView)
        self.view.addSubview(lottieAnimationView)
        
        titleImageView.snp.makeConstraints { make in
            titleImageView.contentMode = .scaleAspectFill
            make.top.equalToSuperview().inset(134)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
        
        lottieAnimationView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func determineNextStep() {
        guard NWMonitor.shared.isInternetAvailable else {
            showAlert()
            return
        }
        
        guard UserData.isUserLogin else {
            setStartButton()
            return
        }
        
        AFHandler.loginBySNS { status in
            DispatchQueue.main.async {
                guard status == .success else {
                    self.showAlert()
                    return
                }
                
                
                self.goToMain()
            }
        }
    }
    
    private func setStartButton() {
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44 * 4.9)
            make.top.equalTo(lottieAnimationView.snp.bottom).offset(29)
        }
    }
    
    private func goToMain()  {
        guard let vc = UIStoryboard(name: StoryBoard.main.name, bundle: nil).instantiateViewController(withIdentifier: MainViewController.identifier) as? MainViewController
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
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func goToQuestionVC() {
        let view = WalkthroughMainViewController()
        view.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(view, animated: true)
        }
    }
    
    private func loadUserDataFromServer(downDone: ((Bool) -> Void)?) {
        // MARK: 서버로부터 유저 데이터 받아오는 곳.
        downDone?(true)
    }
}
