//
//  WalkthroughSecondViewController.swift
//  WineFineThankU
//
//  Created by suding on 2022/03/01.
//

import UIKit

enum PriceOfWine: String, CaseIterable {
    case one2Two = "2만원 이하"
    case thr2Four = "3 ~ 4만원대"
    case five2Seven = "5 ~ 7만원 대"
    case eig2Ten = "8 ~ 10만원 대"
    case quality = "퀄리티가 된다면 가격은 상관없음!"
    var str: String { return self.rawValue }
}

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
    
    let one2Two: UIButton = {
        let button = UIButton()
        button.setTitle(PriceOfWine.one2Two.str, for: .normal)
        
        let action = UIAction(handler: { _ in
            UserDefaults.standard.set("1", forKey: "secondValue")
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let thr2Four: UIButton = {
        let button = UIButton()
        button.setTitle(PriceOfWine.thr2Four.str, for: .normal)
        
        let action = UIAction(handler: { _ in
            UserDefaults.standard.set("2", forKey: "secondValue")
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let five2Seven: UIButton = {
        let button = UIButton()
        button.setTitle(PriceOfWine.five2Seven.str, for: .normal)
        
        let action = UIAction(handler: { _ in
            UserDefaults.standard.set("3", forKey: "secondValue")
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    let eig2Ten: UIButton = {
        let button = UIButton()
        button.setTitle(PriceOfWine.eig2Ten.str, for: .normal)
        
        let action = UIAction(handler: { _ in
            UserDefaults.standard.set("4", forKey: "secondValue")
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    let quality: UIButton = {
        let button = UIButton()
        button.setTitle(PriceOfWine.quality.str, for: .normal)
        
        let action = UIAction(handler: { _ in
            UserDefaults.standard.set("5", forKey: "secondValue")
        })
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
            make.height.equalTo(228)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setupConfigure() {
        view.addSubview(numberLabel)
        view.addSubview(QuestionLabel)
        view.addSubview(stackView)
        buttons = [one2Two, thr2Four, five2Seven, eig2Ten, quality]
        buttons.forEach { btn in
            stackView.addArrangedSubview(btn)
            btn.backgroundColor = .white
            btn.titleLabel?.font = .systemFont(ofSize: 15)
            btn.setTitleColor(.black, for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            btn.addAction(UIAction { _ in
                btn.backgroundColor = .white
                btn.layer.borderColor = UIColor.standardColor.cgColor
                btn.layer.borderWidth = 1.5
                btn.setTitleColor(.standardColor, for: .normal)
                self.selectedBtn(btn)
            }, for: .touchUpInside)
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
              let select = PriceOfWine.allCases.first(where: { $0.str == btnTxt})
        else { return }
        
        delegate?.selected(1, select)
    }
}
