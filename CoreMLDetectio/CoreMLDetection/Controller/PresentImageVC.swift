//
//  ShowImageVC.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/23/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit
import AVKit


class PresentImageVC: UIViewController {
    
    
    
    lazy var captureImageViewPresenImage: UIImageView = {
        var captureImage = ScaledHeightImageView()
        captureImage.clipsToBounds = true
        captureImage.contentMode = .scaleAspectFit
        captureImage.layer.shadowRadius = 4
        captureImage.layer.shadowOpacity = 0.5
        captureImage.layer.borderColor = UIColor.black.cgColor
        captureImage.layer.zPosition = 1
        captureImage.translatesAutoresizingMaskIntoConstraints = false
        return captureImage
    }()
    
    private var iconNav: UIImageView = {
        var icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named: "core")
        icon.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private var mainCameraView: UIView = {
        var myView = UIView()
        myView.backgroundColor = UIColor.white
        myView.layer.zPosition = 0
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addSubview()
        setupConstraints()
       
        self.navigationItem.titleView = iconNav
        
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButton))
    }
    
    @objc func shareButton() {
       
        UIGraphicsBeginImageContext(captureImageViewPresenImage.image!.size)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        
        UIGraphicsEndImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    fileprivate func addSubview() {
        [captureImageViewPresenImage, mainCameraView].forEach{view.addSubview($0)}
    }
    
    
    fileprivate func setupConstraints() {
        
        captureImageViewPresenImage.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, size: .init(width: 300, height: 350))
        
        captureImageViewPresenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureImageViewPresenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        mainCameraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    
    }
    
}










