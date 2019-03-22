//
//  ViewController.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/21/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var photoData: Data?
    let sharedController = CameraController()
    var imagePicker: UIImagePickerController?

    
    
    private var mainCameraView: UIView = {
       var myView = UIView()
        myView.backgroundColor = UIColor.orange
        myView.layer.zPosition = 0
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
        
        
        
    }()
    
    private var captureImageView: UIImageView = {
        var captureImage = ScaledHeightImageView()
        captureImage.backgroundColor = .red
        captureImage.clipsToBounds = true
        captureImage.contentMode = .scaleAspectFit
        
        captureImage.translatesAutoresizingMaskIntoConstraints = false
        return captureImage
    }()
    
    
    private var customToolbar: UIView = {
        var customView = UIView()
        customView.backgroundColor = .customGreyColor()
        
        customView.layer.zPosition = 2
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    
        private var accessPhotoLibrary: UIButton = {
            var button = UIButton(type: .custom)
            
            button.setImage(UIImage(named: "photo"), for: .normal)
            button.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
            button.layer.zPosition = 3
            button.animate()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    
    private var cameraButton: UIButton = {
        var button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        button.layer.zPosition = 3
        button.animate()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var savePhotoToAlbum: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "save"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 3
        button.addTarget(self, action: #selector(saveImagetoPhotAlbum), for: .touchUpInside)
        return button
        
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharedController.cameraPreviewLayer?.frame = mainCameraView.bounds
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        
       
        DispatchQueue(label: "prepare").async {
            self.sharedController.startCaptureSession()
            self.sharedController.setupDevice()
            self.sharedController.setupInputOutput()
            self.sharedController.setupPreviewLayer()
            self.sharedController.startRunningCaptureSession()
        }
   
    }
    

    
    @objc func captureImage() {
        sharedController.captureImage()
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc fileprivate func saveImagetoPhotAlbum() {
        guard let selectedImage = captureImageView.image else {
            showAlertWith(title: "Error", message: "You Need To First Taka a Photo or Chose One From Libary")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            //We got back an error!
            showAlertWith(title: "Error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved", message: "Your image has been saved to your photos.")
            
        }
    }
    
    
    @objc func toggleFlash() {
       if sharedController.flashMode == .on {
           sharedController.flashMode = .off
            //toggleFlashButton.setBackgroundImage(#imageLiteral(resourceName: "recordButton"), for: .normal, barMetrics: .default)
        } else {
            sharedController.flashMode = .on
            //toggleFlashButton.setBackgroundImage(#imageLiteral(resourceName: "recordButton"), for: .normal, barMetrics: .default)    }
        }
    }
    
    

    
    fileprivate func addSubview() {
        [customToolbar,mainCameraView, captureImageView, savePhotoToAlbum, accessPhotoLibrary, cameraButton].forEach{view.addSubview($0)}
    }
    
    
    fileprivate func setupConstraints() {
        
        mainCameraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
     
        
        customToolbar.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        
        
        captureImageView.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, size: .init(width: 300, height: 350))
        
        captureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        savePhotoToAlbum.anchor(top: customToolbar.topAnchor, bottom: customToolbar.bottomAnchor, leading: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0), size: .init(width: 40, height: 40))
        
        savePhotoToAlbum.centerXAnchor.constraint(equalTo: customToolbar.centerXAnchor).isActive = true
         savePhotoToAlbum.centerYAnchor.constraint(equalTo: customToolbar.centerYAnchor).isActive = true
        
        accessPhotoLibrary.anchor(top: nil, bottom: customToolbar.bottomAnchor, leading: nil, trailing: customToolbar.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 5), size: .init(width: 40, height: 40))
        
        
        cameraButton.anchor(top: customToolbar.topAnchor, bottom: customToolbar.bottomAnchor, leading: customToolbar.leadingAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 0 ), size: .init(width: 40, height: 40))
    }

}

extension ViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()
            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
        }
    }
}



extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            captureImageView.contentMode = .scaleToFill
            captureImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }


}
