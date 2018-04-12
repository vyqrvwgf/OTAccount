//
//  OTNormalButton.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/15.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import OTExtension
import SnapKit

public class OTButton: UIButton {
    
    public struct OTButtonConfig {
        public var frame: CGRect = .zero
        public var title: String = ""
        public var titleColor: UIColor = .black
        public var fontSize: CGFloat = 15.0
        public var cornerRadius: CGFloat = 0.0
        public var backgroundColor: UIColor = .white
        public var borderColor: UIColor = .white
        public var borderWidth: CGFloat = 0.0
        public var imageName: String = ""
        public init() {
            
        }
    }
    
    // MARK: - Public
    public func setupNormal(state: UIControlState = .normal, config: (()->(OTButtonConfig))?) {
        if let normalButtonConfig = config?() {
            setup(config: normalButtonConfig, state: state)
        }
    }
    
    public func isShowIndicator(isShow: Bool) {
        isShow ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(20.0)
            make.centerY.equalTo(self)
            make.width.height.equalTo(10.0)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setup(config: OTButtonConfig, state: UIControlState) {
        setTitle(config.title, for: state)
        setTitleColor(config.titleColor, for: state)
        setImage(UIImage(named: config.imageName), for: state)
        titleLabel?.font = UIFont.systemFont(ofSize: config.fontSize)
        backgroundColor = config.backgroundColor
        indicator.activityIndicatorViewStyle = config.backgroundColor == .white ? .gray : .white
        if config.cornerRadius > 0 {
            layer.cornerRadius = config.cornerRadius
            layer.masksToBounds = true
        }
        if config.borderWidth > 0 {
            layer.borderWidth = config.borderWidth
            layer.borderColor = config.borderColor.cgColor
        }
    }
    
    // MARK: - Lazy Load
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return indicator
    }()
}

public extension OTButton {
    // 登录按钮的配置
    public class var loginConfig: OTButtonConfig {
        get {
            var config = OTButtonConfig()
            config.title = "login"
            config.titleColor = .black
            config.fontSize = 15.0
            config.cornerRadius = 5.0
            config.borderWidth = 1.0
            config.borderColor = .separatorGrey
            config.backgroundColor = .white
            return config
        }
    }
    
    // 微信登录的配置
    public class var wechatLoginConfig: OTButtonConfig {
        get {
            var config = OTButtonConfig()
            config.title = "wechat_login"
            config.titleColor = .white
            config.fontSize = 15.0
            config.cornerRadius = 5.0
            config.borderWidth = 1.0
            config.borderColor = .separatorGrey
            config.backgroundColor = .blue
            return config
        }
    }
}
