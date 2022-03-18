//
//  WineListDialog.swift
//  wineFindThankyou
//
//  Created by 허문용 on 2022/03/12.
//

import UIKit
class WineListDialog : UIView{
    private let xibName = "WineListDialog"
    @IBOutlet private weak var wineListDialogSet: UIView!
    @IBOutlet private weak var wineListView: UIView!
    @IBOutlet private weak var wineListTileLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var wineListViewHeight: NSLayoutConstraint!
    internal var wineListArray : [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedTableRow : ((Int) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder : coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        addSubview(wineListDialogSet)
        wineListDialogSet.frame = self.bounds
        wineListView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        wineListView.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        
        wineListTileLabel.text = "와인선택"
        let nibCell = UINib(nibName: "WineListCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "WineListCell")
        tableView.estimatedRowHeight = 44
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}

extension WineListDialog : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WineListCell", for: indexPath) as? WineListCell else {
            return UITableViewCell()
        }
        cell.label.text = wineListArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTableRow?(indexPath.row)
    }
}
