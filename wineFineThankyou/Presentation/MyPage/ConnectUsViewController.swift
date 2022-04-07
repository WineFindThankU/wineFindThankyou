//
//  ConnectUsViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/31.
//

import UIKit
import Foundation
import MessageUI


class ConnectUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var inquireView: UIView!
    @IBOutlet weak var inquireBtn: UIButton!
    
    private unowned var topView: TopView!
    private unowned var emailTxtField: UITextField!
    private unowned var inquireTxtField: UITextField!
    private unowned var inquireTxtView: UITextView!
    
    private var keyboardHeight: CGFloat = 0.0
    
    private var mailTitle: String?
    private var mailText: String?
    private var usersEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        inquireBtn.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }
    
    private func configure() {
        topView = getGlobalTopView(self.view, height: 44)
        topView.titleLabel?.text = "1:1문의하기"
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.leftButton?.addAction(UIAction { _ in self.dismiss(animated: true) }, for: .touchUpInside)
        
        let emailView = setLabelTextField(self.emailView)
        emailView.label.text = "이메일 주소"
        emailView.txtField.placeholder = "답변 받을 이메일 주소를 입력해주세요."
        emailTxtField = emailView.txtField
        
        let inquireView = setLabelTextField(self.inquireView)
        inquireView.label.text = "문의 내용"
        inquireView.txtField.placeholder = "제목을 입력해주세요."
        inquireTxtField = inquireView.txtField
        additionalTxtView(inquireView.txtField)
        
        inquireBtn.setTitle("문의하기", for: .normal)
        inquireBtn.setTitleColor(Theme.white.color, for: .normal)
        inquireBtn.backgroundColor = Theme.purple.color
        inquireBtn.layer.cornerRadius = 14
    }
    
    private func setLabelTextField(_ superView: UIView) -> (label: UILabel, txtField: UITextField) {
        let label = UILabel()
        let txtField = UITextField()
        txtField.delegate = self
        label.translatesAutoresizingMaskIntoConstraints = false
        txtField.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(label)
        superView.addSubview(txtField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
            label.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 20),
            
            txtField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            txtField.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 20),
            txtField.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -20),
            txtField.heightAnchor.constraint(equalToConstant: 40)
        ])
        label.font = UIFont.boldSystemFont(ofSize: 13)
        txtField.layer.borderWidth = 0.2
        txtField.layer.cornerRadius = 4
        txtField.font = UIFont.systemFont(ofSize: 13)
        txtField.addLeftPadding()
        
        return (label, txtField)
    }
    
    private func additionalTxtView(_ upperView: UITextField){
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        self.inquireView.addSubview(txtView)
        
        NSLayoutConstraint.activate([
            txtView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 16),
            txtView.leftAnchor.constraint(equalTo: self.inquireView.leftAnchor, constant: 20),
            txtView.rightAnchor.constraint(equalTo: self.inquireView.rightAnchor, constant: -20),
            txtView.heightAnchor.constraint(equalToConstant: 180)
        ])
        inquireTxtView = txtView
        
        txtView.text = "내용을 입력해주세요."
        txtView.delegate = self
        txtView.layer.borderWidth = 0.2
        txtView.layer.cornerRadius = 4
        txtView.font = UIFont.systemFont(ofSize: 13)
        txtView.textColor = UIColor(rgb: 0xbdbdbd)
        txtView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10);
    }
    
    @objc
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
                
                let bodyString = """
                                 이곳에 내용을 작성해주세요.
                                 -------------------
                                 WineFindThankU
                                 -------------------
                                 """
                
                composeViewController.setToRecipients(["winefindthankyou@gmail.com"])
                composeViewController.setSubject("[와인파인땡큐] 문의 및 의견")
                composeViewController.setMessageBody(bodyString, isHTML: false)
                
                self.present(composeViewController, animated: true, completion: nil)
            } else {
                print("메일 보내기 실패")
                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패",
                                                           message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                
                sendMailErrorAlert.addAction(goAppStoreAction)
                sendMailErrorAlert.addAction(cancleAction)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
        }
    
    
    @objc
    private func closeVC(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTxtField.resignFirstResponder()
        self.inquireTxtField.resignFirstResponder()
        self.inquireTxtView.resignFirstResponder()
        self.view.endEditing(true)
    }
 }

extension ConnectUsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTxtField {
            usersEmail = textField.text
        } else if textField == inquireTxtField {
            mailTitle = textField.text
        }
    }
}

extension ConnectUsViewController: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "내용을 입력해주세요." {
            textView.text = ""
            textView.textColor = Theme.blacktext.color
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        mailText = textView.text
    }
}

