//
//  OTLoginController.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/15.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import OTBaseModular
import OTUIKit
import OTMacro
import OTExtension

public class OTLoginController: OTBaseController {
    
    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bind()
    }

    // MARK: - Custom Method
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(backItem)
        view.addSubview(loginTitleLabel)
        view.addSubview(mobileTextField)
        view.addSubview(mobileTipsLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordTipsLabel)
        view.addSubview(rememberButton)
        view.addSubview(forgetButton)
        view.addSubview(loginButton)
        view.addSubview(tipsLabel)
        view.addSubview(wechatLoginButton)
        view.addSubview(registerButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50.0)
            make.centerX.equalTo(view)
        }
        backItem.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(20.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(50.0)
        }
        loginTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backItem)
            make.leading.equalTo(backItem.snp.trailing).offset(10.0)
        }
        mobileTextField.snp.makeConstraints { (make) in
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(50.0)
            make.leading.equalTo(backItem)
            make.trailing.equalTo(view).offset(-20.0)
            make.height.equalTo(kStandardHeight)
        }
        mobileTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mobileTextField.snp.bottom).offset(5.0)
            make.leading.equalTo(mobileTextField)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(mobileTextField.snp.bottom).offset(30.0)
            make.leading.trailing.height.equalTo(mobileTextField)
        }
        passwordTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5.0)
            make.leading.equalTo(passwordTextField)
        }
        rememberButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20.0)
            make.leading.equalTo(passwordTextField)
        }
        forgetButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view).offset(-20.0)
            make.centerY.equalTo(rememberButton)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(forgetButton.snp.bottom).offset(40.0)
            make.centerX.equalTo(view)
            make.width.equalTo(view.bounds.width-50.0)
            make.height.equalTo(kStandardHeight)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(20.0)
            make.centerX.equalTo(loginButton)
        }
        wechatLoginButton.snp.makeConstraints { (make) in
            make.top.equalTo(tipsLabel.snp.bottom).offset(20.0)
            make.leading.trailing.height.equalTo(loginButton)
        }
        registerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20.0)
        }
    }
    
    private func bind() {
        let viewModel = OTLoginViewModel(
            input: (mobile: mobileTextField.rx.text.orEmpty.asObservable(),
                    password: passwordTextField.rx.text.orEmpty.asObservable(),
                    loginTap: loginButton.rx.tap.asObservable()),
            dependency: OTDefaultValidation.defaultValidation)
        
        viewModel.mobileValid.bind(to: mobileTipsLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.passwordValid.bind(to: passwordTipsLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.everythingValid.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.logining.bind(to: loginButton.rx.isShowIndicator).disposed(by: disposeBag)
        viewModel.logined.subscribe { (result) in
//            OTRoute.changeRoot(classType: .Main, parameter: nil)
        }.disposed(by: disposeBag)
        
        // FIXME: 修改到ViewModel里面处理
        rememberButton.rx.tap.subscribe { (_) in
            self.rememberButton.isSelected = !self.rememberButton.isSelected
        }.disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe { (_) in
            let registerController = OTRegisterController(parameter: ["type": 1])
            self.navigationController?.present(registerController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        Observable<Bool>.create { (sequence) -> Disposable in
            sequence.on(.next(UserDefaults.standard.bool(forKey: kRememberPassword)))
            return Disposables.create()
        }.bind(to: rememberButton.rx.isSelected).disposed(by: disposeBag)
    }
    
    // MARK: - Event
    @objc private func onClickBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lazy Load
    private lazy var titleLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            return OTLabel.titleConfig
        })
        return label
    }()
    
    private lazy var backItem: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.imageName = "login_btnReturn"
            return config
        })
        button.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginTitleLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            var detailTitleConfig = OTLabel.detailTitleConfig
            detailTitleConfig.title = Bundle.localizedString(text: "login_login_title")
            return detailTitleConfig
        })
        return label
    }()
    
    private lazy var mobileTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "login_mobile_placeholder")
            config.keyboardType = .phonePad
            return config
        })
        return textField
    }()
    
    private lazy var mobileTipsLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            return OTLabel.warningTipsConfig
        })
        return label
    }()
    
    private lazy var passwordTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.OTTextFieldConfig()
            config.placeholder = Bundle.localizedString(text: "login_password_placeholder")
            config.fontSize = 15.0
            config.isShowUnderline = true
            config.security = true
            config.isShowEye = true
            return config
        })
        return textField
    }()
    
    private lazy var passwordTipsLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            return OTLabel.warningTipsConfig
        })
        return label
    }()
    
    private lazy var rememberButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.title = Bundle.localizedString(text: "login_remember")
            config.titleColor = .lightGray
            return config
        })
        button.setupNormal(state: .selected, config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            return config
        })
        return button
    }()
    
    private lazy var forgetButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.title = Bundle.localizedString(text: "login_forget")
            config.titleColor = .orange
            return config
        })
        return button
    }()
    
    private lazy var loginButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            return OTButton.loginConfig
        })
        return button
    }()
    
    private lazy var tipsLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            var config = OTLabel.tipsConfig
            config.title = Bundle.localizedString(text: "login_tips")
            return config
        })
        return label
    }()
    
    private lazy var wechatLoginButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            return OTButton.wechatLoginConfig
        })
        return button
    }()
    
    private lazy var registerButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.title = Bundle.localizedString(text: "login_register")
            config.titleColor = .orange
            config.fontSize = 11
            return config
        })
        return button
    }()
}
