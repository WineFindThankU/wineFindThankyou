//
//  WalkthroughFourthViewController.swift
//  WineFineThankU
//
//  Created by suding on 2022/03/01.
//

import UIKit
import SnapKit

final class WalkthroughFourthViewController: UIViewController {
    
    var finalImage = ""
    var finalTitle = ""
    
    var selectedOption: [Any] = [] {
        didSet{ saveUserDefaults() }
    }
    
    lazy var finalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 187")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var finalTitleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "finalTitle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var grapeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .standardColor
        return label
    }()
    
    lazy var firstLabel: UILabel = {
        let label = UILabel()
        if let option = selectedOption[0] as? WhenDoSelect {
            label.text = " # \(option.str)"
        }
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 66 / 255,
                                  green: 66 / 255,
                                  blue: 66 / 255, alpha: 1.0)
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        if let option = selectedOption[1] as? PriceOfWine {
            label.text = " # \(option.str)"
        }
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 66 / 255,
                                  green: 66 / 255,
                                  blue: 66 / 255, alpha: 1.0)
        return label
    }()
    
    lazy var thirdLabel: UILabel = {
        let label = UILabel()
        if let option = selectedOption[2] as? ReasonOfBought {
            label.text = " # \(option.str)"
        }
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 66 / 255,
                                  green: 66 / 255,
                                  blue: 66 / 255, alpha: 1.0)
        return label
    }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "_question_s")
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        let action = UIAction(handler: { _ in
            let nextVC = LoginViewController2()
            nextVC.modalPresentationStyle = .overFullScreen
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                guard let top = topViewController() else { return }
                top.present(nextVC, animated: true) // 루트뷰를 제외한 모든뷰 제거
            })
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        setupUI()
    }
    
    private func setupConfigure() {
        view.addSubview(finalImageView)
        view.addSubview(grapeTitle)
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        view.addSubview(thirdLabel)
        view.addSubview(nextButton)
    }

    // TODO: 폰트 받게 된다면, 적용하겠습니다. 
    private func setupImage() {
        finalImage = GrapeIcon().setupImage(UserData.userOptions)
        finalTitle = GrapeIcon().setupTitle(UserData.userOptions)
        finalImageView.image = UIImage(named: finalImage)
        grapeTitle.text = "나는야" + finalTitle
    }

    private func saveUserDefaults() {
        guard let option0 = selectedOption[0] as? WhenDoSelect,
              let option1 = selectedOption[1] as? PriceOfWine,
              let option2 = selectedOption[2] as? ReasonOfBought
        else { return }
        print("munyong > \(option0.str), \(option1.str), \(option2.str)")
        
        UserData.userOptions = [option0.str, option1.str, option2.str]
        setupImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        finalImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(67)
        }
        
        grapeTitle.snp.makeConstraints { make in
            make.top.equalTo(finalImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(grapeTitle.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.height.width.equalTo(69)
        }
    }
}
