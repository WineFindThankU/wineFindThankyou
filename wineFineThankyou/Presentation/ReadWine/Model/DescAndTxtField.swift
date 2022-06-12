//
//  DescAndTxtField.swift
//  wineFindThankyou
//
//  Created by mun on 2022/06/12.
//

import UIKit

struct DescAndTxtField {
    let label = UILabel()
    let txtField = UITextField()
    init(_ desc: String, _ contents: String?, superView: UIView, isPlaceHolder: Bool = false) {
        label.text = desc
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(rgb: 0x1e1e1e)
        
        if isPlaceHolder {
            txtField.placeholder = contents
        } else {
            txtField.text = contents
        }
        
        txtField.font = UIFont.systemFont(ofSize: 13)
        txtField.layer.cornerRadius = 10
        txtField.setPadding(left: 12, right: 12)
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor(rgb: 0xe0e0e0).cgColor
        
        superView.addSubview(self.label)
        superView.addSubview(self.txtField)
        label.translatesAutoresizingMaskIntoConstraints = false
        txtField.translatesAutoresizingMaskIntoConstraints = false
    }
}
