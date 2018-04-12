//
//  OTNormalLabel.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/15.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit

public class OTLabel: UILabel {

    public struct OTLabelConfig {
        public var frame: CGRect = .zero
        public var title: String = ""
        public var titleColor: UIColor = .black
        public var fontSize: CGFloat = 15.0
        public var cornerRadius: CGFloat = 0.0
        public var backgroundColor: UIColor = .white
        public var borderColor: UIColor = .white
        public var borderWidth: CGFloat = 0.0
        public var numberOfLines: Int = 1
        public var textAlignment: NSTextAlignment = .left
        public init() {
            
        }
    }
    
    // MARK: - Public
    public func setupNormal(config: (()->(OTLabelConfig))?) {
        if let normalLabelConfig = config?() {
            setup(config: normalLabelConfig)
        }
    }
    
    // MARK: - Custom Method
    private func setup(config: OTLabelConfig) {
        text = config.title
        textColor = config.titleColor
        font = UIFont.systemFont(ofSize: config.fontSize)
        numberOfLines = config.numberOfLines
        textAlignment = config.textAlignment
        backgroundColor = config.backgroundColor
        if config.cornerRadius > 0 {
            layer.cornerRadius = config.cornerRadius
            layer.masksToBounds = true
        }
        if config.borderWidth > 0 {
            layer.borderWidth = config.borderWidth
            layer.borderColor = config.borderColor.cgColor
        }
    }
}

public extension OTLabel {
    
    public class var titleConfig: OTLabelConfig {
        get {
            var config = OTLabel.OTLabelConfig()
            config.title = "login_title"
            config.titleColor = .black
            config.fontSize = 20.0
            return config
        }
    }
    
    public class var detailTitleConfig: OTLabelConfig {
        get {
            var config = OTLabel.OTLabelConfig()
            config.fontSize = 22.0
            config.titleColor = .black
            return config
        }
    }
    
    public class var tipsConfig: OTLabelConfig {
        get {
            var config = OTLabel.OTLabelConfig()
            config.fontSize = 11.0
            config.titleColor = .lightGray
            config.textAlignment = .center
            return config
        }
    }
    
    public class var warningTipsConfig: OTLabelConfig {
        get {
            var config = OTLabel.OTLabelConfig()
            config.fontSize = 11.0
            config.titleColor = .orange
            return config
        }
    }
}
