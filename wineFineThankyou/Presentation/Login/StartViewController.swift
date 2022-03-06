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
    
    let animationView = Lottie.AnimationView(name: "WinefindThankU_motion_2")
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchTitle")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
            animationView.contentMode = .scaleAspectFill
            make.top.equalToSuperview().inset(270)
            make.centerX.equalToSuperview()
        }
        animationView.play()
        animationView.loopMode = .loop
    }

    @IBAction func onClickStart(_ sender: Any) {
        let view = WalkthroughMainViewController()
        view.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(view, animated: true)
        }
    }
}
