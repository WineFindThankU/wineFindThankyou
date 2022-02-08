//
//  ConnectUsViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/31.
//

import Foundation
import UIKit
import SwiftSMTP

class ConnectUsViewController: UIViewController {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var inquireView: UIView!
    @IBOutlet weak var inquireBtn: UIButton!
    
    private unowned var topView: TopView!
    private unowned var emailTxtField: UITextField!
    private unowned var inquireTxtField: UITextField!
    private unowned var inquireTxtView: UITextView!
    
    private var mailTitle: String?
    private var mailText: String?
    private var usersEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        inquireBtn.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }
    
    private func configure() {
        topView = setTopView(self.view, height: 44)
        topView.titleLabel?.text = "1:1문의하기"
        topView.rightButton?.setBackgroundImage(UIImage(named: "close"), for: .normal)
        topView.rightButton?.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
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
        txtField.layer.borderWidth = 1
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
        txtView.layer.borderWidth = 1
        txtView.font = UIFont.systemFont(ofSize: 13)
        txtView.textColor = Theme.gray.color
    }
    
    @objc
    private func sendEmail() {
        guard let usersEmail = usersEmail else { return }
        let mailFrom = Mail.User(name: "사용자", email: usersEmail) //보내는 사람 이름/이메일, 이메일 형식 유효하지 않은 경우 error.
        let mailTo = Mail.User(name: "받는사람", email: "munyong.heo@timeblocks.com") // WFT 이름/이메일 주소
        let mail = Mail(from: mailFrom, to: [mailTo], subject: "subject", text: "text")
        SMTP(hostname: "smtp.gmail.com",
                       email: "", //WFT 이메일 주소, 비밀번호
                       password: "").send(mail, completion: { error in
            guard let error = error else {
                self.closeVC()
                return
            }
        })
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
