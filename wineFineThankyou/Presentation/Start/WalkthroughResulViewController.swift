//
//  WalkthroughResulViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/04/02.
//

import Foundation
import UIKit

class WalkthroughResulViewController: UIViewController {
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var labelIntroduce: UILabel!
    @IBOutlet weak private var hashTags: UILabel!
    
    @IBAction private func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func nextStep(_ sender: UIButton) {
        guard let nextVC = UIStoryboard(name: StoryBoard.main.name, bundle: nil).instantiateViewController(identifier: LoginViewController.identifier) as? LoginViewController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
            guard let top = topViewController() else { return }
            top.present(nextVC, animated: true) // 루트뷰를 제외한 모든뷰 제거
        })
    }
    private var grapeCase: GrapeCase! {
        didSet {
            UserData.userTasteType = grapeCase.tasteType
        }
    }
    internal var question2Answer: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateUI(getGrapeCase())
    }
    
    private func updateUI(_ answers: [String]) {
        imgView.image = grapeCase.grapeImage
        labelIntroduce.text = "나는야\n" + grapeCase.grapeName + " 포도알"
        guard answers.count > 0 else { return }
        
        var hashTags: String = ""
        answers.forEach {
            hashTags += "#" + $0 + "\n"
        }
        self.hashTags.text = hashTags
    }
    
    private func getGrapeCase() -> [String] {
        guard let answer0 = question2Answer[QuestionList.question0.rawValue],
              let answer1 = question2Answer[QuestionList.question1.rawValue],
              let answer2 = question2Answer[QuestionList.question2.rawValue]
        else { return [] }
        
        UserData.userOptions = [answer0, answer1, answer2]
        if answer0 == WhenDoSelect.cost.str
            || answer1 == PriceOfWine.one2Two.str
            || answer1 == PriceOfWine.thr2Four.str {
            self.grapeCase = GrapeCase.costGrape
            return [answer0, answer1, answer2]
        } else if answer2 == UsuallyBought.restaurant.str
                    || answer2 == UsuallyBought.wineBar.str {
            self.grapeCase = GrapeCase.dionysusGrape
            return [answer0, answer1, answer2]
        } else if answer0.contains("기타") {
            self.grapeCase = GrapeCase.analystGrape
            return [answer0, answer1, answer2]
        } else if answer2 == UsuallyBought.wineShop.str {
            self.grapeCase = GrapeCase.childGrape
            return [answer0, answer1, answer2]
        } else {
            self.grapeCase = GrapeCase.analystGrape
            return [answer0, answer1, answer2]
        }
    }
    
    private func setUI() {
        labelIntroduce.numberOfLines = 0
        hashTags.numberOfLines = 0
        
        labelIntroduce.textColor = UIColor(rgb: 0x7B61FF)
        labelIntroduce.textAlignment = .center
        labelIntroduce.font = UIFont(name: "Gaegu-Regular", size: 32) ?? .systemFont(ofSize: 32)
        
        hashTags.textColor = UIColor(rgb: 0x424242)
        hashTags.textAlignment = .center
        hashTags.font = .systemFont(ofSize: 13)
    }
}
