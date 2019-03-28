//
//  RoundedShadowImageView.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/21/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//


import UIKit

class RoundedShadowImageView: UIImageView {
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = 15
    }
    
}
