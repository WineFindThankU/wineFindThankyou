//
//  WalkthroughThirdViewController.swift
//  WineFineThankU
//
//  Created by suding on 2022/03/01.
//

import UIKit


class WalkthroughThirdViewController: UIViewController {
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Q. 3"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var QuestionLabel: UILabel = {
        let label = UILabel()
        label.text =
        """
        와인을 주로
        구입하는 이유는?
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
    
    let forMe: UIButton = {
        let button = UIButton()
        button.setTitle(ReasonOfBought.forMe.str, for: .normal)
        
        let action = UIAction(handler: { _ in
            UserDefaults.standard.set("1", forKey: "thirdValue")
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let forParty: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(ReasonOfBought.forParty.str, for: .normal)
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
            
            UserDefaults.standard.set("2", forKey: "thirdValue")
            
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let presentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(ReasonOfBought.forPresent.str, for: .normal)
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
            UserDefaults.standard.set("3", forKey: "thirdValue")
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    internal weak var delegate: SelectWalkThroughOption?
    private var buttons = [UIButton]()
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
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupConfigure() {
        view.addSubview(numberLabel)
        view.addSubview(QuestionLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(forMe)
        stackView.addArrangedSubview(forParty)
        stackView.addArrangedSubview(presentButton)
        buttons = [forMe, forParty, presentButton]
        buttons.forEach { btn in
            btn.backgroundColor = .white
            btn.titleLabel?.font = .systemFont(ofSize: 15)
            btn.setTitleColor(.black, for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
             let action = UIAction { _ in
                 btn.layer.borderColor = UIColor.standardColor.cgColor
                 btn.setTitleColor(.standardColor, for: .normal)
                 btn.layer.borderWidth = 1.5
                 self.selectedBtn(btn)
             }
            btn.addAction(action, for: .touchUpInside)
        }
    }
    
    private func selectedBtn(_ btn: UIButton) {
        self.buttons.filter {
            $0 != btn
        }.forEach {
            $0.layer.borderColor = UIColor(rgb: 0xE0E0E0).cgColor
            $0.setTitleColor(UIColor(rgb: 0xbdbdbd), for: .normal)
        }
        
        guard let btnTxt = btn.titleLabel?.text,
              let select = ReasonOfBought.allCases.first(where: { $0.str == btnTxt})
        else { return }
        delegate?.selected(2, select)
    }
}
