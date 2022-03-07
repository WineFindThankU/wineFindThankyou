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
        animationView.animation = Animation.named("WinefindThankU_motion")
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
        button.layer.cornerRadius = 17
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
    }
    
    private func setupUI() {
        self.view.addSubview(titleImageView)
        self.view.addSubview(lottieAnimationView)
        self.view.addSubview(startButton)
        
        titleImageView.snp.makeConstraints { make in
            titleImageView.contentMode = .scaleAspectFill
            make.top.equalToSuperview().inset(130)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
        
        lottieAnimationView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(80)
            make.height.equalTo(44)
            make.width.equalTo(44 * 4.9)
            make.bottom.equalToSuperview().inset(108)
        }
    }
}
