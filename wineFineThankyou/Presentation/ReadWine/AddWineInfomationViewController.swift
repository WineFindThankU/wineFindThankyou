//
//  AddWineInfomationViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/21.
//

import UIKit

class AddWineInfomationViewController: UIViewController, UIGestureRecognizerDelegate {
    struct AdditionalWineInfo {
        var name: String
        var vintage: String
        var from: String
        var price: String
        var date: String
    }
    
    private weak var topView: TopView!
    private weak var midView: UIView!
    private weak var datePickerView: UIView!
    private weak var textFieldName: UITextField?
    private weak var textFieldFrom: UITextField?
    private weak var textFieldVintage: UITextField?
    private weak var textFieldBoughtPrice: UITextField?
    private weak var textFieldBoughtDate: UITextField?
    private weak var boughtDateBtn: UIButton!
    private weak var registerOkButton: UIButton!
    
    private var captureStatus: CaptureStatus = .initial
    private var capturedImg: UIImage?
    private var dataPicker: UIDatePicker?
    private var additionalWineInfo: AdditionalWineInfo?
    private var wineListDialog: WineListDialog?
    
    internal var shop: Shop!
    internal var delegate: ReloadShopDetail?
    private var isKeyboardShown: Bool = false
    internal var wineAtServer: WineAtServer! {
        didSet { setValueOnTextFields() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextStepByCaptureStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    private func nextStepByCaptureStatus(){
        switch captureStatus {
        case .initial:
            guard let vc = UIStoryboard(name: StoryBoard.readWine.rawValue, bundle: nil).instantiateViewController(withIdentifier: CameraCaptureViewController.identifier) as? CameraCaptureViewController
            else { return }
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: {
                self.captureStatus = .cancel
                vc.delegate = self
            })
            return
        case .cancel:
            close()
        case .ok:
            DispatchQueue.main.async {
                configure()
            }
        }
        
        func configure() {
            self.view.backgroundColor = UIColor(rgb: 0xf4f4f4)
            
            setTopView()
            setMidContentsView()
            setBottomView()
            setDatePickerView()
            delegateSet()
            self.addKeyboardNotifications()
        }
        
        func delegateSet() {
            textFieldName?.delegate = self
            textFieldFrom?.delegate = self
            textFieldVintage?.delegate = self
            textFieldBoughtPrice?.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textFieldName?.resignFirstResponder()
        self.textFieldFrom?.resignFirstResponder()
        self.textFieldVintage?.resignFirstResponder()
        self.textFieldBoughtPrice?.resignFirstResponder()
        
        if datePickerView?.isHidden == false {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                self.datePickerView.transform = CGAffineTransform(translationX: 0, y: 269)
                self.datePickerView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        chkRegisterBtnUI()
    }
    
    private func chkRegisterBtnUI() {
        if let name = self.textFieldName?.text, !name.isEmpty,
           let from = self.textFieldFrom?.text, !from.isEmpty,
           let vintage = self.textFieldVintage?.text, !vintage.isEmpty,
           let date = self.textFieldBoughtDate?.text, !date.isEmpty {
            self.registerOkButton.backgroundColor = Theme.purple.color
            self.registerOkButton.titleLabel?.textColor = .white
        }
    }
}

extension AddWineInfomationViewController: CapturedImageProtocol {
    func captured(_ uiImage: UIImage?, done: (() -> Void)?) {
        guard let uiImage = uiImage else {
            return
        }
        captureStatus = .ok
        WineLabelReader.doStartToOCR(uiImage) { winesAtServer in
            self.capturedImg = uiImage
            guard !winesAtServer.isEmpty,
                  let wineAtServer = winesAtServer.first
            else {
                self.wineAtServer = WineAtServer()
                done?()
                return
            }
            
            guard winesAtServer.count == 1 else {
                //온 와인의 정보를 alert로 보여주고 선택하게끔 함.
                done?()
                return
            }
            self.wineAtServer = wineAtServer
            done?()
        }
    }
}

extension AddWineInfomationViewController {
    private func setTopView() {
        self.topView = getGlobalTopView(self.view, height: 44)
        topView.backgroundColor = .white
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(goToPreviousStep), for: .touchUpInside)
    }
    
    private func setMidContentsView() {
        let midView = UIView()
        let imageView = UIImageView()
        self.view.addSubview(midView)
        midView.addSubview(imageView)
        midView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let wineName = DescAndTxtField("와인 명", additionalWineInfo?.name, superView: midView)
        let wineFrom = DescAndTxtField("원산지", additionalWineInfo?.from, superView: midView)
        let wineVintage = DescAndTxtField("빈티지", additionalWineInfo?.vintage, superView: midView)
        
        NSLayoutConstraint.activate([
            midView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            midView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            midView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            midView.heightAnchor.constraint(equalToConstant: 318),
            
            imageView.topAnchor.constraint(equalTo: midView.topAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: midView.leftAnchor, constant: 20),
            imageView.rightAnchor.constraint(equalTo: midView.rightAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 110),

            wineName.label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            wineName.label.leftAnchor.constraint(equalTo: midView.leftAnchor, constant: 20),
            wineName.label.rightAnchor.constraint(equalTo: midView.rightAnchor, constant: -20),
            wineName.label.heightAnchor.constraint(equalToConstant: 18),
            
            wineName.txtField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            wineName.txtField.leftAnchor.constraint(equalTo: midView.leftAnchor, constant: 20),
            wineName.txtField.rightAnchor.constraint(equalTo: midView.rightAnchor, constant: -20),
            wineName.txtField.heightAnchor.constraint(equalToConstant: 46),
            
            wineFrom.label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 112),
            wineFrom.label.leftAnchor.constraint(equalTo: midView.leftAnchor, constant: 20),
            wineFrom.label.widthAnchor.constraint(equalToConstant: 160),
            wineFrom.label.heightAnchor.constraint(equalToConstant: 18),
            
            wineFrom.txtField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 138),
            wineFrom.txtField.leftAnchor.constraint(equalTo: midView.leftAnchor, constant: 20),
            wineFrom.txtField.widthAnchor.constraint(equalToConstant: 160),
            wineFrom.txtField.heightAnchor.constraint(equalToConstant: 46),
            
            wineVintage.label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 112),
            wineVintage.label.leftAnchor.constraint(equalTo: wineFrom.label.rightAnchor, constant: 15),
            wineVintage.label.rightAnchor.constraint(equalTo: midView.rightAnchor, constant: -20),
            wineVintage.label.heightAnchor.constraint(equalToConstant: 18),
            
            wineVintage.txtField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 138),
            wineVintage.txtField.leftAnchor.constraint(equalTo: wineFrom.txtField.rightAnchor, constant: 15),
            wineVintage.txtField.rightAnchor.constraint(equalTo: midView.rightAnchor, constant: -20),
            wineVintage.txtField.heightAnchor.constraint(equalToConstant: 46),
        ])
        
        midView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.capturedImg
        wineVintage.txtField.keyboardType = .numberPad
        
        self.midView = midView
        textFieldName = wineName.txtField
        textFieldFrom = wineFrom.txtField
        textFieldVintage = wineVintage.txtField
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [flexibleSpace, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor(rgb: 0x7b61ff)
        textFieldBoughtPrice?.inputAccessoryView = toolBarKeyboard
        textFieldVintage?.inputAccessoryView = toolBarKeyboard
    }
    
    @objc
    private func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }
    
    private func setBottomView() {
        let bottomView = UIView()
        let registerOkButton = UIButton()
        let boughtDateBtn = UIButton()
        self.view.addSubview(bottomView)
        bottomView.addSubview(registerOkButton)
        bottomView.addSubview(boughtDateBtn)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        boughtDateBtn.translatesAutoresizingMaskIntoConstraints = false
        registerOkButton.translatesAutoresizingMaskIntoConstraints = false
        let boughtPrice = DescAndTxtField("구매한 가격", "구매한 가격을 입력해주세요.", superView: bottomView, isPlaceHolder: true)
        let boughtDate = DescAndTxtField("구매한 날짜", "구매한 날짜를 선택해주세요.", superView: bottomView, isPlaceHolder: true)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: self.midView.bottomAnchor, constant: 8),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            boughtPrice.label.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            boughtPrice.label.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            boughtPrice.label.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            boughtPrice.label.heightAnchor.constraint(equalToConstant: 18),
            
            boughtPrice.txtField.topAnchor.constraint(equalTo: boughtPrice.label.bottomAnchor, constant: 8),
            boughtPrice.txtField.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            boughtPrice.txtField.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            boughtPrice.txtField.heightAnchor.constraint(equalToConstant: 46),
            
            boughtDate.label.topAnchor.constraint(equalTo: boughtPrice.txtField.bottomAnchor, constant: 16),
            boughtDate.label.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            boughtDate.label.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            boughtDate.label.heightAnchor.constraint(equalToConstant: 18),

            boughtDate.txtField.topAnchor.constraint(equalTo: boughtDate.label.bottomAnchor, constant: 8),
            boughtDate.txtField.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            boughtDate.txtField.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            boughtDate.txtField.heightAnchor.constraint(equalToConstant: 46),
            
            boughtDateBtn.topAnchor.constraint(equalTo: boughtDate.txtField.topAnchor),
            boughtDateBtn.leftAnchor.constraint(equalTo: boughtDate.txtField.leftAnchor),
            boughtDateBtn.rightAnchor.constraint(equalTo: boughtDate.txtField.rightAnchor),
            boughtDateBtn.bottomAnchor.constraint(equalTo: boughtDate.txtField.bottomAnchor),
            
            registerOkButton.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            registerOkButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            registerOkButton.widthAnchor.constraint(equalToConstant: 335),
            registerOkButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        bottomView.backgroundColor = .white
        
        boughtDate.txtField.isEnabled = false
        boughtPrice.txtField.keyboardType = .numberPad
        self.textFieldBoughtPrice = boughtPrice.txtField
        self.textFieldBoughtDate = boughtDate.txtField
        boughtDateBtn.addTarget(self, action: #selector(pickBoughtDate), for: .touchUpInside)
        boughtDateBtn.backgroundColor = .clear
        self.boughtDateBtn = boughtDateBtn
        registerOkButton.backgroundColor = UIColor(rgb: 0xf5f5f5)
        registerOkButton.layer.cornerRadius = 22
        registerOkButton.setTitle("등록하기", for: .normal)
        registerOkButton.setTitleColor(UIColor(rgb: 0xbdbdbd), for: .normal)
        registerOkButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        registerOkButton.addTarget(self, action: #selector(completeRegister), for: .touchUpInside)
        self.registerOkButton = registerOkButton
    }
    
    private func setDatePickerView(){
        let datePickerView = UIView()
        let datePicker = UIDatePicker()
        let okButton = UIButton()
        
        self.view.addSubview(datePickerView)
        datePickerView.addSubview(datePicker)
        datePickerView.addSubview(okButton)
        
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePickerView.heightAnchor.constraint(equalToConstant: 269),
            datePickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            datePickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            datePickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 269),
            
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor, constant: 16),
            datePicker.leftAnchor.constraint(equalTo: datePickerView.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: datePickerView.rightAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 161),
            
            okButton.bottomAnchor.constraint(equalTo: datePickerView.safeAreaLayoutGuide.bottomAnchor, constant: -22),
            okButton.centerXAnchor.constraint(equalTo: datePickerView.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 335),
            okButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        self.view.bringSubviewToFront(datePickerView)
        
        datePickerView.backgroundColor = .white
        datePickerView.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        okButton.layer.cornerRadius = 22
        okButton.backgroundColor = UIColor(rgb: 0x7B61FF)
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        okButton.addTarget(self, action: #selector(completeDateSet), for: .touchDown)
        
        self.datePickerView = datePickerView
        self.dataPicker = datePicker
    }
    
    private func setValueOnTextFields(){
        DispatchQueue.main.async { [weak self] in
            let name = self?.wineAtServer.korName
            let from = self?.wineAtServer.from
            self?.additionalWineInfo = AdditionalWineInfo(name: name ?? "",
                                                    vintage: "",
                                                    from: from ?? "",
                                                    price: "", date: "")
            self?.textFieldName?.text = self?.additionalWineInfo?.name
            self?.textFieldFrom?.text = self?.additionalWineInfo?.from
            self?.textFieldVintage?.text = self?.additionalWineInfo?.vintage
            self?.textFieldBoughtPrice?.text = self?.additionalWineInfo?.price
        }
    }
    
    @objc
    private func goToPreviousStep() {
        self.captureStatus = .initial
        nextStepByCaptureStatus()
    }
    
    private func close() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc
    func completeDateSet() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            self.datePickerView.transform = CGAffineTransform(translationX: 0, y: 269)
            self.datePickerView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        guard let date = self.dataPicker?.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        additionalWineInfo?.date = dateFormatter.string(from: date)
        textFieldBoughtDate?.text = self.additionalWineInfo?.date
        
        chkRegisterBtnUI()
    }
    
    @objc
    func pickBoughtDate() {
        datePickerView.isHidden = false
        self.view.bringSubviewToFront(datePickerView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.datePickerView.transform = CGAffineTransform(translationX: 0, y: -269)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func completeRegister() {
        guard let additionalWineInfo = additionalWineInfo,
        !additionalWineInfo.name.isEmpty,
        !additionalWineInfo.from.isEmpty,
        !additionalWineInfo.vintage.isEmpty,
        !additionalWineInfo.date.isEmpty
        else { return }
        
        AFHandler.searchWine(byKeyword: additionalWineInfo.name) {
            guard $0.count > 1 else {
                register()
                return
            }
            self.showWinesInfoServer($0) { wine in
                register(selectedKey: wine.key)
            }
        }
        
        func register(selectedKey: String = ""){
            let param = ["sh_no": shop.key,
                         "wn_no": selectedKey.isEmpty ? wineAtServer.key : selectedKey,
                         "name": additionalWineInfo.name,
                         "country": additionalWineInfo.from,
                         "vintage": additionalWineInfo.vintage,
                         "price_range": additionalWineInfo.price,
                         "purchased_at": additionalWineInfo.date] as Dictionary
            AFHandler.addWine(param) { isSuccess in
                guard isSuccess else {
                    print("와인 등록 실패")
                    return
                }
                
                AFHandler.shopDetail(self.shop.key, done: {
                    guard let resShop = $0 else { return }
                    self.delegate?.addShopDetail(resShop)
                    self.close()
                })
            }
        }
    }
    
    private func showWinesInfoServer(_ winesAtServer: [WineAtServer], done:((WineAtServer) -> Void)?) {
        let wineListDialog = WineListDialog()
        
        let nameArr = winesAtServer.compactMap { $0.korName }
        wineListDialog.wineListArray.removeAll()
        wineListDialog.wineListArray.append(contentsOf: nameArr)
        
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        wineListDialog.frame = keyWindow!.bounds
        DispatchQueue.main.async {
            keyWindow!.addSubview(wineListDialog)
            self.wineListDialog = wineListDialog
        }
        wineListDialog.selectedTableRow = {
            wineListDialog.removeFromSuperview()
            self.wineListDialog = nil
            done?(winesAtServer[$0])
        }
    }
}

extension AddWineInfomationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty, textField.isEqual(textFieldVintage),
              let currentString  = textField.text
        else { return true }
        
        let rtnVal: Bool = currentString.count < 4
        if !rtnVal { textFieldVintage?.resignFirstResponder() }
        
        return rtnVal
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if additionalWineInfo == nil {
            additionalWineInfo = AdditionalWineInfo(name: "",
                                                    vintage: "",
                                                    from: "",
                                                    price: "",
                                                    date: "")
        }
        
        if textField.isEqual(textFieldName) {
            additionalWineInfo?.name = textFieldName?.text ?? ""
        } else if textField.isEqual(textFieldFrom) {
            additionalWineInfo?.from = textFieldFrom?.text ?? ""
        } else if textField.isEqual(textFieldVintage) {
            additionalWineInfo?.vintage = textFieldVintage?.text ?? ""
            if let text = textField.text, text.count >= 4 {
                textField.resignFirstResponder()
            }
        } else if textField.isEqual(textFieldBoughtPrice) {
            let val = (textFieldBoughtPrice?.text ?? "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")
            var realValue: String = ""
            val.reversed().enumerated().forEach { idx, c in
                realValue.append(c)
                if idx % 3 == 2 {
                    realValue += ","
                }
            }
            additionalWineInfo?.price = val
            textFieldBoughtPrice?.text = realValue.reversed() + (realValue.isEmpty ? "" : "원")
        }
    }
}

extension AddWineInfomationViewController {
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        guard !isKeyboardShown else { return }
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height / 2
            self.view.frame.origin.y -= keyboardHeight
            isKeyboardShown = true
        }
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        guard isKeyboardShown else { return }
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height / 2
            
            self.view.frame.origin.y += keyboardHeight
            isKeyboardShown = false
        }
    }
}

enum CaptureStatus {
    case initial
    case cancel
    case ok
}
