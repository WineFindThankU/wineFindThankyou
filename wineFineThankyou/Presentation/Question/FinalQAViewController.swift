//
//  FinalQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/23.
//

import UIKit

class FinalQAViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClickNextButton(_ sender: Any) {
        //MARK 로그인 화면으로 넘어가야 한다.
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
