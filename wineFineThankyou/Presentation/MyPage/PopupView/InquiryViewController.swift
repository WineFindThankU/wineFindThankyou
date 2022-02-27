//
//  InquiryViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation
import UIKit
import SnapKit

final class InquiryViewController: UIViewController {
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text =
            """
            1:1 문의가 접수되었습니다!
            이메일로 답변이 가니 조금만 기다려주세요
            """
        label.textColor = .standardFont
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인했어요!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .standardColor
        button.layer.cornerRadius = 10
        let action = UIAction { _ in
            let nextViewController = MyPageViewController()
            nextViewController.modalPresentationStyle = .overFullScreen
            self.present(nextViewController, animated: true)
            self.dismiss(animated: true)
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
        alertView.addSubview(okButton)
    }

    private func setupLayout() {
        alertView.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(194)
            make.centerY.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.centerX.equalToSuperview()
        }
    
        okButton.snp.makeConstraints { make in
            make.height.equalTo(270)
            make.width.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }
}
