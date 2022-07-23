//
//  WalkthroughView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/04/02.
//

import Foundation
import UIKit

class WalkthroughView: UIView{
    @IBOutlet private var contentsView: UIView!
    @IBOutlet private weak var walkthroughView: UIView!
    @IBOutlet private weak var labelQuestion: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var nextBtn: UIButton!
    @IBAction func nextBtnAction(_ sender: UIButton) {
        nextBtnClosure?()
    }
    
    private var buttons: [UIButton] = []
    internal var delegate: AfterWalkthroughAnswer?
    internal var nextBtnClosure: (() -> Void)?
    internal var questionNumber: Int = 0 {
        didSet { updateUI() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func updateUI() {
        guard let question = QuestionList(rawValue: questionNumber) else { return }
        self.labelQuestion.text = question.str
        
        buttons.removeAll()
        question.optionList.enumerated().forEach { idx, optionObj in
            let btn = UIButton()
            stackView.addArrangedSubview(btn)
            btn.setTitle(title: optionObj, colorHex: 0x1e1e1e, font: .systemFont(ofSize: 15))
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor(rgb: 0x1e1e1e).cgColor
            btn.contentEdgeInsets = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
            btn.layer.cornerRadius = 18
            btn.addAction(UIAction { _ in
                btn.backgroundColor = .white
                btn.layer.borderColor = UIColor.standardColor.cgColor
                btn.layer.borderWidth = 1.5
                btn.setTitleColor(.standardColor, for: .normal)
                self.selectedBtn(idx, btn)
            }, for: .touchUpInside)
            
            buttons.append(btn)
        }
        stackViewHeight.constant = CGFloat(question.optionList.count) * 44
    }
}

extension WalkthroughView {
    private func configure() {
        Bundle.main.loadNibNamed("WalkthroughView", owner: self, options: nil)
        addSubview(contentsView)
        contentsView.backgroundColor = .clear
        contentsView.frame = self.bounds
        walkthroughView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        walkthroughView.layer.cornerRadius = 10
        
        labelQuestion.textColor = .black
        labelQuestion.textAlignment = .center
        labelQuestion.numberOfLines = 0
        labelQuestion.font = .systemFont(ofSize: 22, weight: .regular)
        
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        nextBtn.setImage(UIImage(named: "UnselectedWalkthroughNextBtn"), for: .normal)
    }
    
    private func selectedBtn(_ idx: Int, _ btn: UIButton) {
        btn.layer.borderColor = UIColor(rgb: 0x7B61FF).cgColor
        btn.setTitleColor(UIColor(rgb: 0x7B61FF), for: .normal)
        
        self.buttons.filter {
            $0 != btn
        }.forEach {
            $0.layer.borderColor = UIColor(rgb: 0xE0E0E0).cgColor
            $0.setTitleColor(UIColor(rgb: 0xbdbdbd), for: .normal)
        }
        
        nextBtn.setImage(UIImage(named: "SelectedWalkthroughNextBtn"), for: .normal)
        
        let isEtcetera: Bool = (questionNumber == QuestionList.question0.rawValue &&
            idx == QuestionList.question0.optionList.count - 1)
        delegate?.selected(questionNumber, btn.titleLabel?.text, isEtcetera)
    }
}


