//
//  CameraCaptureViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/12.
//

import Foundation
import UIKit
import AVFoundation

protocol CapturedImageProtocol: AnyObject {
    func captured(_ uiImage: UIImage?, done: (() -> Void)?)
}

class CameraCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var describeView: UIView!
    @IBOutlet private weak var topView: TopView!
    @IBOutlet private weak var okButton: UIButton!
    @IBAction private func okButtonAction(_ sender: UIButton) {
        self.setCamera()
    }
    
    private let captureSession = AVCaptureSession()
    private var cameraDevice: AVCaptureDevice!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private let photoOutput : AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        output.isHighResolutionCaptureEnabled = true
        return output
    }()
    
    internal var delegate: CapturedImageProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show How To Capture WineLabel
        showDescribeView()
    }
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
    
    private func showDescribeView() {
        topView = getGlobalTopView(self.describeView, height: 44)
        topView.rightButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        topView.rightButton?.setBackgroundImage(UIImage(named: "Close"), for: .normal)
        okButton.setTitle(title: "확인했어요!", colorHex: 0xFFFFFF, backColor: UIColor(rgb: 0x7b61ff), font: .systemFont(ofSize: 17))
    }
    
    private func setCamera() {
        initCameraDevice()
        initCameraInAndOutputData()
        displayPreview()
        startRunning()
        initFrameView()
    }
    
    private func initCameraDevice() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else { return }
        
        cameraDevice = captureDevice
    }
    
    private func initCameraInAndOutputData() {
        guard let cameraDevice = self.cameraDevice else { return }
        do {
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            captureSession.addOutput(photoOutput)
        } catch {
            return
        }
    }
    
    private func displayPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        DispatchQueue.main.async {
            self.describeView.isHidden = false
            self.videoPreviewLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.videoPreviewLayer)
        }
    }
    
    private func startRunning() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                setCaputureView()
            }
        }
        
        func setCaputureView() {
            let captureRectView = CaptureRectView.init(frame: self.view.bounds, bgColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5), transRect: CGRect.init(x: 107, y: 93, width: 180, height: 488))
            let captureBtn = UIButton()
            let label = UILabel()
            self.view.addSubview(captureRectView)
            captureRectView.addSubViews(subViews: label, captureBtn)
            self.view.bringSubviewToFront(captureRectView)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: captureRectView.centerXAnchor, constant: -111),
                label.centerYAnchor.constraint(equalTo: captureRectView.centerYAnchor, constant: -70),
                captureBtn.widthAnchor.constraint(equalToConstant: 66),
                captureBtn.heightAnchor.constraint(equalToConstant: 66),
                captureBtn.centerXAnchor.constraint(equalTo: captureRectView.centerXAnchor),
                captureBtn.bottomAnchor.constraint(equalTo: captureRectView.bottomAnchor, constant: -24)
            ])
            
            label.setTitle(title: "라벨을 가이드 선에 맞게 가로로 촬영해주세요.", colorHex: 0xffffff, font: .systemFont(ofSize: 15))
            label.transform = CGAffineTransform(rotationAngle: Double.pi / 2).translatedBy(x: 0, y: 0)
            captureBtn.setBackgroundImage(UIImage(named: "Capture"), for: .normal)
            captureBtn.layer.cornerRadius = 22
            captureBtn.addTarget(self, action: #selector(self.capture), for: .touchUpInside)
            captureBtn.transform = CGAffineTransform(rotationAngle: Double.pi / 2).translatedBy(x: 0, y: 0)
        }
    }
    
    private func initFrameView() {
        self.view.addSubview(self.cameraView)
        self.view.bringSubviewToFront(self.cameraView)
    }
    
    @objc
    private func capture() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        
        delegate?.captured(uiImage) {
            self.captureSession.stopRunning()
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
}
