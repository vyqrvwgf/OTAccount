//
//  OTColorExtension.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/14.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit

public extension UIColor {
    
    class var randomColor: UIColor {
        get {
            return UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        }
    }
    
    class var separatorGrey: UIColor {
        get {
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
}
