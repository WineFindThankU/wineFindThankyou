//
//  WalkthroughSecondViewController.swift
//  WineFineThankU
//
//  Created by suding on 2022/03/01.
//

import UIKit

class WalkthroughSecondViewController: UIViewController {
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Q. 2"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var QuestionLabel: UILabel = {
        let label = UILabel()
        label.text =
        """
        내가 일상적으로
        마시는 와인은 얼마?
        """
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
   
    private var selectedFlag = false
    
    let stackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.backgroundColor = .white
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    } ()
    
    let twoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("2만원 이하", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            button.layer.borderWidth = 1.5
            UserDefaults.standard.set("2만원 이하", forKey: "second")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let threefourButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("3 ~ 4만원대", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            button.layer.borderWidth = 1.5
            UserDefaults.standard.set("3 ~ 4만원대", forKey: "second")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let fivesevenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("5 ~ 7만원 대", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            button.layer.borderWidth = 1.5
            UserDefaults.standard.set("5 ~ 7만원대", forKey: "second")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    let eighttenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("8 ~ 10만원 대", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            button.layer.borderWidth = 1.5
            UserDefaults.standard.set("8 ~ 10만원대", forKey: "second")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let qualityButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("퀄리티가 된다면 가격은 상관없음!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let action = UIAction { _ in
            button.layer.borderColor = UIColor.standardColor.cgColor
            button.setTitleColor(.standardColor, for: .normal)
            button.layer.borderWidth = 1.5
            UserDefaults.standard.set("퀄리티가 된다면 가격은 상관없는", forKey: "second")
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
            make.height.equalTo(228)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setupConfigure() {
        view.addSubview(numberLabel)
        view.addSubview(QuestionLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(twoButton)
        stackView.addArrangedSubview(threefourButton)
        stackView.addArrangedSubview(fivesevenButton)
        stackView.addArrangedSubview(eighttenButton)
        stackView.addArrangedSubview(qualityButton)
    }
    
    private func setupButton() {
        
    }
}
