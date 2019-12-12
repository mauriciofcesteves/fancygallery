//
//  UITableViewCell+ApplyShadow.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-10.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

extension UIView {
    
    /** Apply shadow around the view. */
    func applyShadow(shadowRadius: CGFloat = 5, height: CGFloat = 0) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: height)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
    }
    
    /** Apply shadow to the bottom of the view. */
    func applyBottomShadow() {
        self.applyShadow(shadowRadius: 1.0, height: 3.0)
    }
}
