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
    private weak var backgroundView: UIView!
    private weak var textFieldName: UITextField?
    private weak var textFieldFrom: UITextField?
    private weak var textFieldVintage: UITextField?
    private weak var textFieldBoughtDate: UIButton?
    private weak var boughtDateBtn: UIButton!
    private var captrueStatus: CaptureStatus = .initial
    
    internal var readWineInfo: ReadWineInfo! = ReadWineInfo(name: "까시엘로 델 ", from: "칠레", vintage: "2019")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        delegateSet()
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
            }
        }
    }
    
    private func delegateSet() {
        textFieldName?.delegate = self
        textFieldFrom?.delegate = self
        textFieldVintage?.delegate = self
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor(rgb: 0xf4f4f4)
        
        setTopView()
        setMidContentsView()
        setBottomView()
        setDatePickerView()
        setBackgroundView()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissCurrentTop))
        recognizer.delegate = self
        self.backgroundView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func dismissCurrentTop(){
        if textFieldName?.isEditing == true {
            textFieldName?.resignFirstResponder()
        } else if textFieldFrom?.isEditing == true {
            textFieldFrom?.resignFirstResponder()
        } else if textFieldVintage?.isEditing == true {
            textFieldVintage?.resignFirstResponder()
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                self.datePickerView.transform = CGAffineTransform(translationX: 0, y: 269)
                self.view.layoutIfNeeded()
            }
        }
        self.backgroundView.isHidden = true
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
            print($0)
            done?()
        }
    }
}

extension AddWineInfomationViewController {
    private func setBackgroundView(){
        let backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        backgroundView.backgroundColor = .black.withAlphaComponent(0.1)
        self.backgroundView = backgroundView
        self.backgroundView.isHidden = true
    }
    
    private func setTopView() {
        self.topView = getGlobalTopView(self.view, height: 44)
        topView.backgroundColor = .white
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setMidContentsView(image: UIImage? = nil) {
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
        imageView.image = image
        self.midView = midView
        
        textFieldName = wineName.txtField
        textFieldFrom = wineFrom.txtField
        textFieldVintage = wineVintage.txtField
    }
    
    private func setBottomView() {
        let bottomView = UIView()
        let okButton = UIButton()
        let boughtDateBtn = UIButton()
        self.view.addSubview(bottomView)
        bottomView.addSubview(okButton)
        bottomView.addSubview(boughtDateBtn)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        boughtDateBtn.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        let boughtDate = DescAndTxtField("구매한 날짜", "구매한 날짜를 선택해주세요.", superView: bottomView)
        
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
            
            okButton.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            okButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 335),
            okButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        bottomView.backgroundColor = .white
        
        boughtDate.txtField.isEnabled = false
        
        boughtDateBtn.addTarget(self, action: #selector(pickBoughtDate), for: .touchUpInside)
        boughtDateBtn.backgroundColor = .clear
        self.boughtDateBtn = boughtDateBtn
        okButton.backgroundColor = UIColor(rgb: 0xf5f5f5)
        okButton.layer.cornerRadius = 22
        okButton.setTitle("등록하기", for: .normal)
        okButton.setTitleColor(UIColor(rgb: 0xbdbdbd), for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
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
        
        self.datePickerView = datePickerView
    }
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
    @objc
    func pickBoughtDate() {
        self.view.bringSubviewToFront(backgroundView)
        self.view.bringSubviewToFront(datePickerView)
        self.backgroundView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.datePickerView.transform = CGAffineTransform(translationX: 0, y: -269)
            self.view.layoutIfNeeded()
        }
    }
}

extension AddWineInfomationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.backgroundView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.backgroundView.isHidden = true
        if textField.isEqual(textFieldName) {
            readWineInfo.changeName(textFieldName?.text ?? "")
        } else if textField.isEqual(textFieldFrom) {
            readWineInfo.changeFrom(textFieldFrom?.text ?? "")
        } else if textField.isEqual(textFieldVintage) {
            readWineInfo.changeVintage(textFieldVintage?.text ?? "")
        }
    }
}

struct DescAndTxtField {
    let label = UILabel()
    let txtField = UITextField()
    init(_ desc: String, _ placeholder: String, superView: UIView) {
        label.text = desc
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(rgb: 0x1e1e1e)
        
        txtField.placeholder = placeholder
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

struct ReadWineInfo {
    var name: String
    var from: String
    var vintage: String
    var boughtDate: Date = Date()
    mutating func changeName(_ name: String) {
        self.name = name
    }
    mutating func changeFrom(_ from: String) {
        self.from = from
    }
    mutating func changeVintage(_ vintage: String) {
        self.vintage = vintage
    }
    mutating func changeBoughtDate(_ date: Date) {
        self.boughtDate = date
    }
}
enum CaptureStatus {
    case initial
    case cancel
    case ok
}
