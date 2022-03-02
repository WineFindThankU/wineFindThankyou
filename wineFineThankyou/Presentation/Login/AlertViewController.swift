//
//  AlertViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/09.
//

import UIKit


final class AlertViewController: UIViewController {
   
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입은 성인만 가능합니다.\n 다음에 꼭 다시 만나요!"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()



    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .standardColor
        button.layer.cornerRadius = 15
        let action = UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.centerY.centerX.equalToSuperview()

            alertView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.centerX.equalToSuperview()
            }

            alertView.addSubview(acceptButton)
            acceptButton.snp.makeConstraints { make in
                make.height.equalTo(44)
                make.width.equalTo(270)
                make.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }

    }
}
