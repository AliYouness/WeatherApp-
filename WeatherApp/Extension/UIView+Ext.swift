//
//  UIView+Ext.swift
//  WeatherApp
//
//  Created by Ali Youness on 10/25/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
