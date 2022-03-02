//
//  WalkthroughFourthViewController.swift
//  WineFineThankU
//
//  Created by suding on 2022/03/01.
//

import UIKit
import SnapKit

final class WalkthroughFourthViewController: UIViewController {
    
    private let firstData = UserDefaults.standard.object(forKey: "first")!
    private let secondData = UserDefaults.standard.object(forKey: "second")!
    private let thirdData = UserDefaults.standard.object(forKey: "third")!
    
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
    
    lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.text = " # \(firstData)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 66 / 255,
                                  green: 66 / 255,
                                  blue: 66 / 255, alpha: 1.0)
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = " # \(secondData)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 66 / 255,
                                  green: 66 / 255,
                                  blue: 66 / 255, alpha: 1.0)
        return label
    }()
    
    lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.text = " # \(thirdData)"
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
            let nextVC = LoginViewController()
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: false)
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
        view.addSubview(finalTitleImageView)
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        view.addSubview(thirdLabel)
        view.addSubview(nextButton)
    }

    
    private func setupUI() {
        view.backgroundColor = .white
        finalImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(67)
        }
        
        finalTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(finalImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(174)
            make.height.equalTo(56)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(finalTitleImageView.snp.bottom).offset(36)
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
