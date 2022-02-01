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
    struct SendContents {
        let title: String
        let question: String
        let usersEmail: String
    }
    
    private unowned var mailTitleSection: UILabel!
    private unowned var mailTitle: UITextField!
    private unowned var mailContents: UITableView!
    private unowned var usersEmail: UITextField!
    private unowned var sendButton: UIButton!
    private var smtp : SMTP {
        return SMTP(hostname: "smtp.gmail.com",
                    email: "", //이메일 주소
                    password: "") //이메일 비밀번호
    }
    
    let mailFrom = Mail.User(name: "", email: "") //보내는 사람 이름/이메일
    let mailTo = Mail.User(name: "", email: "") // 받는 사람 이름/이메일
    var mail : Mail?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        sendButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }
    
    private func configure() {
        let sendButton = UIButton()
        self.view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            sendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 75),
            sendButton.heightAnchor.constraint(equalToConstant: 75),
        ])
        sendButton.backgroundColor = .red
        self.sendButton = sendButton
    }
    
    @objc
    private func sendEmail() {
        mail = Mail(from: mailFrom, to: [mailTo], subject: "subject", text: "text")
        smtp.send(mail!, completion: { error in
            print("send Mail : \(error.debugDescription)")
        })
    }
}
