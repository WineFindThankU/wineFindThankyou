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
    func captured(_ uiImage: UIImage?)
}

class CameraCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var cameraView: UIView!
    
    private let captureSession = AVCaptureSession()
    private var cameraDevice: AVCaptureDevice!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var photoOutput : AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        output.isHighResolutionCaptureEnabled = true
        return output
    }()
    
    internal var delegate: CapturedImageProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCameraDevice()
        initCameraInAndOutputData()
        displayPreview()
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
            print(error.localizedDescription)
            return
        }
    }
    
    private func displayPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.videoPreviewLayer)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                setCaputureButton()
            }
        }
        
        func setCaputureButton() {
            let btn = UIButton()
            self.view.addSubview(btn)
            self.view.bringSubviewToFront(btn)
            btn.backgroundColor = .purple
            btn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                btn.widthAnchor.constraint(equalToConstant: 45),
                btn.heightAnchor.constraint(equalToConstant: 45),
                btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
            ])
            btn.layer.cornerRadius = 22
            btn.addTarget(self, action: #selector(self.capture), for: .touchUpInside)
        }
    }
    
    private func initFrameView() {
        self.view.addSubview(cameraView)
        self.view.bringSubviewToFront(cameraView)
    }
    
    @objc
    private func capture() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        
        delegate?.captured(uiImage)
        self.dismiss(animated: true, completion: {
            self.captureSession.stopRunning()
        })
    }
}
