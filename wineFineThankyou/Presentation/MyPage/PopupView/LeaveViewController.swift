//
//  LeaveViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation
import UIKit
import SnapKit

final class LeaveViewController: UIViewController {
    private weak var activityIndicator: UIActivityIndicatorView?
    private lazy var alertView: UIView = {
        return setAlertView()
    }()
    private lazy var titleLabel: UILabel = {
        return setTitleLabel()
    }()
    private lazy var logoutButton: UIButton = {
        return setLeaveButton()
    }()
    private lazy var cancelButton: UIButton = {
        return setCancelButton()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    private func getActionWhenBeLeave() -> UIAction {
        return UIAction { _ in
            self.showIndicator()
            
            deleteAllOfBoughtWines { isDeleteSuccess in
                guard isDeleteSuccess else {
                    DispatchQueue.main.async {
                        self.showErrorAlert()
                    }
                    return
                }
                
                AFHandler.getLeave(UserData.accessToken) { isLeaveSuccess in
                    guard isLeaveSuccess else {
                        DispatchQueue.main.async {
                            self.showErrorAlert()
                        }
                        return
                    }
                    
                    UserData.isUserLogin = false
                    UserData.accessToken = ""
                    
                    DispatchQueue.main.async {
                        goToStartViewController()
                    }
                }
            }
            
            
            func deleteAllOfBoughtWines(done: ((Bool) -> Void)?){
                AFHandler.getMyPageData { myPageData in
                    let boughtWineKeys = myPageData?.boughtWines.compactMap {
                        $0.wineInfo?.key
                    } ?? []
                    
                    guard !boughtWineKeys.isEmpty else { done?(true); return }
                    
                    var count = 0
                    boughtWineKeys.forEach { key in
                        AFHandler.deleteWine(key) { isSuccess in
                            guard isSuccess else { done?(false); return }
                            
                            count += 1
                            if count == boughtWineKeys.count {
                                done?(isSuccess)
                            }
                        }
                    }
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
    }
    
    private func showIndicator() {
        let indicator = activityIndicator ?? UIActivityIndicatorView()
        self.view.addSubview(indicator)
        
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = false
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.startAnimating()
        activityIndicator = indicator
    }
    
    private func hiddenIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "오류",
                                      message: "인터넷 연결 상태가 좋지 않아 회원탈퇴에 실패하였습니다. 다시 시도해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

//MARK: UI
extension LeaveViewController {
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(alertView)
        titleLabel.numberOfLines = 0
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
            make.leading.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().offset(-24)
        }

        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.width.equalTo(100)
            make.leading.equalTo(cancelButton.snp.trailing).offset(20)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func setTitleLabel() -> UILabel {
        let label = UILabel()
        label.text =
            """
            탈퇴 후 모든 정보는 삭제됩니다.
            정말 탈퇴하시겠어요?
            """
        label.textColor = .standardFont
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }
    
    private func setLeaveButton() -> UIButton {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .standardColor
        button.layer.cornerRadius = 10
        button.addAction(getActionWhenBeLeave(), for: .touchUpInside)
        
        return button
    }
    
    private func setCancelButton() -> UIButton {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.setTitleColor(.standardColor,for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 1
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(rgb: 0x424242).cgColor
        button.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        return button
    }
    
    private func setAlertView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        return view
    }
}
