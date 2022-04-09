//
//  PopupViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation
import UIKit
import SnapKit

final class PopupViewController: UIViewController {
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 로그아웃하시겠어요?"
        label.textColor = .standardFont
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.setTitleColor(.standardColor,for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 1
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(rgb: 0x424242).cgColor
        let action = UIAction { _ in
            self.dismiss(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .standardColor
        button.layer.cornerRadius = 10
        let action = UIAction { _ in
            AFHandler.getLogout(UserData.accessToken) { _ in
                UserData.isUserLogin = false
                UserData.accessToken = ""
                DispatchQueue.main.async {
                    goToStartViewController()
                }
            }
            
            func goToStartViewController() {
                guard let vc = UIStoryboard(name: StoryBoard.start.name,
                                            bundle: nil).instantiateViewController(withIdentifier: StartViewController.identifier) as? StartViewController
                else { return }
                vc.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(vc, animated: true)
                }
            }
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(cancelButton)
        alertView.addSubview(logoutButton)
    }

    private func setupLayout() {
        alertView.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(194)
            make.centerY.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.centerX.equalToSuperview()
        }
    
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.width.equalTo(100)
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-24)
        }

        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.width.equalTo(100)
            make.leading.equalTo(cancelButton.snp.trailing).offset(20)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
