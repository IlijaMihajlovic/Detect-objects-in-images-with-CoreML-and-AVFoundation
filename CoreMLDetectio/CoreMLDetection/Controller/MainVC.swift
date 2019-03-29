//
//  ViewController.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/21/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit
import AVKit

class MainVC: UIViewController, UIGestureRecognizerDelegate {
    
    var photoData: Data?
    let sharedcameraController = CameraController()
    var imagePicker: UIImagePickerController?
    
    
    
    private var mainCameraView: UIView = {
        var myView = UIView()
        myView.backgroundColor = UIColor.orange
        myView.layer.zPosition = 0
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    lazy var captureImageView: UIImageView = {
        var captureImage = ScaledHeightImageView()
        captureImage.backgroundColor = .red
        captureImage.clipsToBounds = true
        captureImage.contentMode = .scaleAspectFit
        
        captureImage.translatesAutoresizingMaskIntoConstraints = false
        return captureImage
    }()
    
    
    private var customToolBar: UIView = {
        var cv = UIView()
        cv.backgroundColor = .lightGray
        cv.layer.zPosition = 3
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    

    
    
    private var accessPhotoLibrary: HighlightedButton = {
        var button = HighlightedButton()
        button.setImage(UIImage(named: "photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.zPosition = 3
        button.tintColor = .black
        button.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var cameraButton: HighlightedButton = {
        var button = HighlightedButton()
        
        button.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.zPosition = 3
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        return button
    }()
    
    private var toggleFlashButton: HighlightedButton = {
        var button = HighlightedButton()
        button.setImage(UIImage(named: "flashOff")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.zPosition = 3
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
       
        return button
    }()
    
    
    private var savePhotoToAlbum: HighlightedButton = {
        var button = HighlightedButton()
        button.setImage(UIImage(named: "save")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.zPosition = 3
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveImagetoPhotAlbum), for: .touchUpInside)
        return button
        
    }()
    
 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharedcameraController.cameraPreviewLayer?.frame = mainCameraView.bounds
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        
        
        
        
        DispatchQueue(label: "prepare").async {
            self.sharedcameraController.startCaptureSession()
            self.sharedcameraController.setupDevice()
            self.sharedcameraController.setupInputOutput()
            self.sharedcameraController.setupPreviewLayer()
            self.sharedcameraController.startRunningCaptureSession()
        }
        
    }
    
  
    
    @objc func captureImage(_ sender: UIButton) {
        sharedcameraController.captureImage()
        
        //Hides the image after two seconds
//        if captureImageView.isHidden == false  {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//                self.captureImageView.isHidden = true
//            }
//
//        } else {
//            self.captureImageView.isHidden = false
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//                self.captureImageView.isHidden = true
//            }
//        }
       sender.popUpAnimation()
 }
    
    @objc func toggleFlash() {
        if sharedcameraController.flashMode == .on {
            sharedcameraController.flashMode = .off
            toggleFlashButton.setImage(UIImage(named: "flashOff"), for: .normal)
        }
        else {
            sharedcameraController.flashMode = .on
            toggleFlashButton.setImage(UIImage(named: "flashOn"), for: .normal)
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc fileprivate func saveImagetoPhotAlbum(_ sender: UIButton) {
        sender.popUpAnimation()
        guard let selectedImage = captureImageView.image  else {
            showAlertWith(title: "Error", message: "You Need To First Taka a Photo")
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
    
 
    
    
    
    
    fileprivate func addSubview() {
        [customToolBar,mainCameraView, captureImageView, savePhotoToAlbum, accessPhotoLibrary, cameraButton, toggleFlashButton].forEach{view.addSubview($0)}
    }
    
  
    
    
    fileprivate func setupConstraints() {
        
        mainCameraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)



        captureImageView.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, size: .init(width: 300, height: 350))

        captureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        customToolBar.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 60))



                savePhotoToAlbum.anchor(top: customToolBar.topAnchor, bottom: customToolBar.bottomAnchor, leading: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0), size: .init(width: 40, height: 40))

                savePhotoToAlbum.centerXAnchor.constraint(equalTo: customToolBar.centerXAnchor).isActive = true
               savePhotoToAlbum.centerYAnchor.constraint(equalTo: customToolBar.centerYAnchor).isActive = true

                accessPhotoLibrary.anchor(top: nil, bottom: customToolBar.bottomAnchor, leading: nil, trailing: customToolBar.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 5), size: .init(width: 40, height: 40))


                cameraButton.anchor(top: customToolBar.topAnchor, bottom: customToolBar.bottomAnchor, leading: customToolBar.leadingAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 0 ), size: .init(width: 40, height: 40))


                toggleFlashButton.anchor(top: customToolBar.topAnchor, bottom: customToolBar.bottomAnchor, leading: savePhotoToAlbum.trailingAnchor, trailing:accessPhotoLibrary.leadingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: 60, height: 60))
        
       
    }
}

extension MainVC: AVCapturePhotoCaptureDelegate {
    
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



extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func pickImage(_ sender: UIButton) {
        sender.popUpAnimation()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    
    //User has picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let presentimage = PresentImageVC()
        
        if let pickedImage = info[.originalImage] as? UIImage {
            presentimage.captureImageViewPresenImage.contentMode = .scaleToFill
            presentimage.captureImageViewPresenImage.image = pickedImage
            presentimage.captureImageViewPresenImage.popUpAnimation()
           
        }
        self.navigationController?.pushViewController(presentimage, animated: true)
       
        
        //Hides the image after two seconds
//        if captureImageView.isHidden == false  {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//                self.captureImageView.isHidden = true
//            }
//
//        } else {
//            self.captureImageView.isHidden = false
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//                self.captureImageView.isHidden = true
//            }
//        }
        
            picker.dismiss(animated: true, completion: nil)
    }
    
    
}
