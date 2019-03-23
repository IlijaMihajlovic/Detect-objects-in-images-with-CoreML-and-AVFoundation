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
    
    
    private var captureImageViewPresentImage: UIImageView = {
        var captureImage = ScaledHeightImageView()
        captureImage.backgroundColor = .red
        captureImage.clipsToBounds = true
        captureImage.contentMode = .scaleAspectFit
        
        captureImage.translatesAutoresizingMaskIntoConstraints = false
        return captureImage
    }()
    
    
    private var customToolbarPresen: UIView = {
        var customView = UIView()
        customView.backgroundColor = .customGreyColor()
        
        customView.layer.zPosition = 2
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
 

}
