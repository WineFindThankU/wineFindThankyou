//
//  WalkthroughFirstViewController.swift
//
//  Created by suding on 2022/03/01.
//

import UIKit

protocol SelectQuestionProtocol {
     func renewButtons(_ sender: UIButton, btns: [UIButton])
 }

class WalkthroughFirstViewController: UIViewController {

    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Q. 1"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var QuestionLabel: UILabel = {
        let label = UILabel()
        label.text =
        """
        와인을 마실 때 나에게
        가장 중요한 것은?
        """
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
   
    private var selectedFlag = false
    
    private func setUserDefaults(value: String) {
        
    }
    let stackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.backgroundColor = .white
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    } ()
    
    let costButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("가성비", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            UserDefaults.standard.set("가성비", forKey: "first")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let grapeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("포도 품종", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            UserDefaults.standard.set("포도 품종", forKey: "first")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let brandButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("와인 브랜드", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            UserDefaults.standard.set("와인 브랜드", forKey: "first")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("생산 지역", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            UserDefaults.standard.set("생산 지역", forKey: "first")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let wineTypeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("와인 종류 (레드/화이트/내추럴 등)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            UserDefaults.standard.set("와인 종류", forKey: "first")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let otherButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("기타 (직접 입력)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            UserDefaults.standard.set("기타", forKey: "first")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConfigure()
        setupUI()
    }
    
    private func setupUI() {
        numberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
        }
        
        QuestionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberLabel.snp.bottom).offset(28)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(QuestionLabel.snp.bottom).offset(40)
            make.height.equalTo(272)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setupConfigure() {
        view.addSubview(numberLabel)
        view.addSubview(QuestionLabel)
        view.addSubview(costButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(costButton)
        stackView.addArrangedSubview(grapeButton)
        stackView.addArrangedSubview(brandButton)
        stackView.addArrangedSubview(locationButton)
        stackView.addArrangedSubview(wineTypeButton)
        stackView.addArrangedSubview(otherButton)
    }
    
    private func setupButton() {
        
    }
}
