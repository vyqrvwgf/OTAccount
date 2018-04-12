//
//  OTNormalTextField.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/15.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import OTExtension
import SnapKit

public class OTTextField: UITextField {

    public struct OTTextFieldConfig {
        public var frame: CGRect = .zero
        public var title: String = ""
        public var titleColor: UIColor = .black
        public var fontSize: CGFloat = 15.0
        public var cornerRadius: CGFloat = 0.0
        public var backgroundColor: UIColor = .white
        public var borderColor: UIColor = .white
        public var borderWidth: CGFloat = 0.0
        public var textAlignment: NSTextAlignment = .left
        public var placeholder: String = ""
        public var security: Bool = false
        public var isShowUnderline: Bool = true
        public var isShowEye: Bool = false
        public var keyboardType: UIKeyboardType = .default
        public init() {
            
        }
    }
    
    // MARK: - Public
    public func setupNormal(config: (()->(OTTextFieldConfig))?) {
        if let normalTextFieldConfig = config?() {
            setup(config: normalTextFieldConfig)
        }
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func layout() {
        addSubview(underlineView)
        
        underlineView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(1.0)
        }
    }
    
    private func setup(config: OTTextFieldConfig) {
        text = config.title
        textColor = config.titleColor
        font = UIFont.systemFont(ofSize: config.fontSize)
        textAlignment = config.textAlignment
        backgroundColor = config.backgroundColor
        placeholder = config.placeholder
        keyboardType = config.keyboardType
        
        underlineView.isHidden = !config.isShowUnderline
        isSecureTextEntry = config.security
        if config.cornerRadius > 0 {
            layer.cornerRadius = config.cornerRadius
            layer.masksToBounds = true
        }
        if config.borderWidth > 0 {
            layer.borderWidth = config.borderWidth
            layer.borderColor = config.borderColor.cgColor
        }
        if config.isShowEye {
            rightViewMode = .always
            rightView = eyeButton
        }
    }
    
    // MARK: - Event
    @objc private func onClickEye() {
        isSecureTextEntry = eyeButton.isSelected
        eyeButton.isSelected = !eyeButton.isSelected
    }
    
    // MARK: - Lazy Load
    private lazy var underlineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .separatorGrey
        view.isHidden = true
        return view
    }()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "closeEye"), for: .normal)
        button.setImage(UIImage(named: "openEye"), for: .selected)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
        button.addTarget(self, action: #selector(onClickEye), for: .touchUpInside)
        return button
    }()
}

public extension OTTextField {
    
    public class var accountInsertConfig: OTTextFieldConfig {
        get {
            var config = OTTextField.OTTextFieldConfig()
            config.fontSize = 15.0
            config.isShowUnderline = true
            return config
        }
    }
}
