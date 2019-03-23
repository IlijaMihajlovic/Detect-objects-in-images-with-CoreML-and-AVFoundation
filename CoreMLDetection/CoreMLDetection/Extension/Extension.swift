//
//  Extension.swift
//  CoreMLDetection
//
//  Created by Ilija Mihajlovic on 3/21/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}



extension UIView {
    
    func popUpAnimation() {
        self.transform = self.transform.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)}, completion: nil)
        }
    }







extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init( red: CGFloat(red) / 255.0,green: CGFloat(green) / 255.0,blue: CGFloat(blue) / 255.0, alpha: a)
  
    }
    
    class func customGreyColor() -> UIColor {
        
        return UIColor(red: 221, green: 221, blue: 221)
    }
}


