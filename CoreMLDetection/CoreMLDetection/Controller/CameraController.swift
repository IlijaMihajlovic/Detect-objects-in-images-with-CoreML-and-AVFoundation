//
//  CameraController.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/22/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit
import AVKit

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate  {
    
    static let sharedInstance = CameraController()

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    
    @objc func  captureImage() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)    }
    
    
    //MARK: Setting up the camera
    func startCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
       currentCamera = backCamera
    }
    
    
    func setupInputOutput() {
        do {
            guard let currentCamera = currentCamera else {return}
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            
            guard let photoOutput = photoOutput else {return}
            
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput)
            
        } catch {
            print(error)
        }
    }
    
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let cameraPreviewLayer = cameraPreviewLayer else { return }
        
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = self.view.frame
        
        self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    
    @objc func didTapCameraView() {
        let settings = AVCapturePhotoSettings()
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

}


