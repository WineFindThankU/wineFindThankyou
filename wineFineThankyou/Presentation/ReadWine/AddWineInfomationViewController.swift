//
//  AddWineInfomationViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/21.
//

import UIKit

class AddWineInfomationViewController: UIViewController, UIGestureRecognizerDelegate {
    private weak var topView: TopView!
    private weak var midView: UIView!
    private weak var datePickerView: UIView!
    private weak var textFieldName: UITextField?
    private weak var textFieldFrom: UITextField?
    private weak var textFieldVintage: UITextField?
    private weak var textFieldBoughtDate: UITextField?
    private weak var boughtDateBtn: UIButton!
    private weak var registerOkButton: UIButton!
    private var captrueStatus: CaptureStatus = .initial
    private var capturedImg: UIImage?
    private var dataPicker: UIDatePicker?
    internal var shop: Shop!
    internal var readWineInfo: ReadWineInfo! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.textFieldName?.text = self?.readWineInfo.name
                self?.textFieldFrom?.text = self?.readWineInfo.from
                self?.textFieldVintage?.text = self?.readWineInfo.vintage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        readWineInfo = ReadWineInfo(name: "", from: "", vintage: "", dateStr: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextStepByCaptureStatus()
    }
    
    private func nextStepByCaptureStatus(){
        switch captrueStatus {
        case .initial:
            guard let vc = UIStoryboard(name: StoryBoard.readWine.rawValue, bundle: nil).instantiateViewController(withIdentifier: CameraCaptureViewController.identifier) as? CameraCaptureViewController
            else { return }
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: {
                self.captrueStatus = .cancel
                vc.delegate = self
            })
            return
        case .cancel:
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        case .ok:
            DispatchQueue.main.async {
                self.configure()
                self.delegateSet()
            }
        }
    }
    
    private func delegateSet() {
        textFieldName?.delegate = self
        textFieldFrom?.delegate = self
        textFieldVintage?.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textFieldName?.resignFirstResponder()
        self.textFieldFrom?.resignFirstResponder()
        self.textFieldVintage?.resignFirstResponder()
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
    
    private func configure() {
        self.view.backgroundColor = UIColor(rgb: 0xf4f4f4)
        
        setTopView()
        setMidContentsView()
        setBottomView()
        setDatePickerView()
    }
}

extension AddWineInfomationViewController: CapturedImageProtocol {
    func captured(_ uiImage: UIImage?, done: (() -> Void)?) {
        guard let uiImage = uiImage else {
            return
        }
        captrueStatus = .ok
        WineLabelReader.doStartToOCR(uiImage) {
        //MARK: uiimage넘겨서 텍스트 읽어야 함. Test code
            self.capturedImg = uiImage
            let readData: ReadWineInfo?
            if $0 == nil {
                readData = ReadWineInfo(name: "", from: "", vintage: "", dateStr: "")
            } else {
                readData = $0
            }
            self.readWineInfo = readData
            done?()
        }
    }
}

extension AddWineInfomationViewController {
    private func setTopView() {
        self.topView = getGlobalTopView(self.view, height: 44)
        topView.backgroundColor = .white
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setMidContentsView() {
        let midView = UIView()
        let imageView = UIImageView()
        self.view.addSubview(midView)
        midView.addSubview(imageView)
        midView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let wineName = DescAndTxtField("와인 명", readWineInfo.name, superView: midView)
        let wineFrom = DescAndTxtField("원산지", readWineInfo.from, superView: midView)
        let wineVintage = DescAndTxtField("빈티지", readWineInfo.vintage, superView: midView)
        
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
        self.midView = midView
        textFieldName = wineName.txtField
        textFieldFrom = wineFrom.txtField
        textFieldVintage = wineVintage.txtField
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
        
        let boughtDate = DescAndTxtField("구매한 날짜", "구매한 날짜를 선택해주세요.", superView: bottomView, isPlaceHolder: true)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: self.midView.bottomAnchor, constant: 8),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            boughtDate.label.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
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
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
    
    @objc
    func completeDateSet() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            self.datePickerView.transform = CGAffineTransform(translationX: 0, y: 269)
            self.view.layoutIfNeeded()
        }
        
        guard let date = self.dataPicker?.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.readWineInfo.dateStr = dateFormatter.string(from: date)
        self.textFieldBoughtDate?.text = dateFormatter.string(from: date)
        
        chkRegisterBtnUI()
    }
    
    @objc
    func pickBoughtDate() {
        self.view.bringSubviewToFront(datePickerView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.datePickerView.transform = CGAffineTransform(translationX: 0, y: -269)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func completeRegister() {
        guard readWineInfo.setComplete() else {
            return
        }
        
        let param = ["sh_no": shop.key,
                     "name": readWineInfo.name,
                     "country": readWineInfo.from,
                     "vintage": readWineInfo.vintage,
                     "purchased_at": readWineInfo.dateStr] as [String : Any]
        AFHandler.addWine(param) { isSuccess in
            //와인추가 완료. 실패/성공 판단 후 dismiss.
            guard isSuccess else {
                print("와인 등록 실패")
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
}

extension AddWineInfomationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(textFieldName) {
            readWineInfo.name = textFieldName?.text ?? ""
        } else if textField.isEqual(textFieldFrom) {
            readWineInfo.from = textFieldFrom?.text ?? ""
        } else if textField.isEqual(textFieldVintage) {
            readWineInfo.vintage = textFieldVintage?.text ?? ""
        }
    }
}

struct DescAndTxtField {
    let label = UILabel()
    let txtField = UITextField()
    init(_ desc: String, _ contents: String, superView: UIView, isPlaceHolder: Bool = false) {
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

enum CaptureStatus {
    case initial
    case cancel
    case ok
}
