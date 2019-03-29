//
//  HighlightedButton.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/28/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit

class HighlightedButton: UIButton {

        override var isHighlighted: Bool {
            didSet {
                tintColor = isHighlighted ? .red : .black
                
            }
        }
    }


