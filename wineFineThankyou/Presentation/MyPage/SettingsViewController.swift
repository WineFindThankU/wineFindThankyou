//
//  SettingsViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/06.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    enum SettingSection0: Int, CaseIterable{
        case connectUs = 0
        var text: String {
            switch self {
            case .connectUs:
                return "1:1문의하기"
            }
        }
    }
    enum SettingSection1: Int, CaseIterable{
        case logout = 0
        case withdraw = 1
        var text: String {
            switch self {
            case .logout:
                return "로그아웃"
            case .withdraw:
                return "회원탈퇴"
            }
        }
    }
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let topView = getGlobalTopView(self.view, height: 44)
        topView.titleLabel?.text = "설정"
        topView.rightButton?.setBackgroundImage(UIImage(named: "close"), for: .normal)
        topView.rightButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.topView.addSubview(topView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
    }
    
    @objc
    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func goToConnectUs(){
        guard let vc = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil).instantiateViewController(withIdentifier: ConnectUsViewController.identifier) as? ConnectUsViewController else { return }
        self.present(vc, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return SettingSection0.allCases.count
        } else if section == 1{
            return SettingSection1.allCases.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell
        else { return UITableViewCell() }
        if indexPath.section == 0{
            guard let opt = SettingSection0(rawValue: indexPath.row) else { return UITableViewCell() }
            cell.label.text = opt.text
            cell.arrow.isHidden = false
        } else if indexPath.section == 1{
            guard let opt = SettingSection1(rawValue: indexPath.row) else { return UITableViewCell() }
            cell.label.text = opt.text
            cell.arrow.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        indexPath.section == 0 ? doSomethingBySection0(indexPath.row) : doSomethingBySection1(indexPath.row)
    }
    
    private func doSomethingBySection0(_ row: Int) {
        if SettingSection0.connectUs.rawValue == row {
            goToConnectUs()
        }
    }
    private func doSomethingBySection1(_ row: Int) {
        if SettingSection1.logout.rawValue == row {
            
        } else if SettingSection1.withdraw.rawValue == row{
            
        }
    }
}


