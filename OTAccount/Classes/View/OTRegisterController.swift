//
//  OTRegisterController.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/16.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import OTBaseModular
import OTUIKit
import OTMacro
import OTRoute

class OTRegisterController: OTBaseController {
    
    // MARK: - Life Cycle
    convenience init(parameter: [String: Any]) {
        self.init()
        let typeRawValue = parameter["type"] as? Int ?? 0
        let type = OTRegisterType(rawValue: typeRawValue) ?? .mobile
        layout(type: type)
        bind(type: type)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = backItem
    }
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    // MARK: - Custom Method
    private func layout(type: OTRegisterType) {
        view.addSubview(registerTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(countryTextField)
        view.addSubview(cityTextField)
        view.addSubview(type == .mail ? mailTextField : mobileTextField)
        view.addSubview(variableTipsLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordTipsLabel)
        view.addSubview(repeatTextField)
        view.addSubview(repeatTipsLabel)
        view.addSubview(registerButton)
        view.addSubview(termsLabel)
        
        registerTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(30.0)
            make.leading.equalTo(view).offset(20.0)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(registerTitleLabel.snp.bottom).offset(30.0)
            make.leading.equalTo(registerTitleLabel)
            make.trailing.equalTo(view).offset(-20.0)
            make.height.equalTo(kStandardHeight)
        }
        countryTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(20.0)
            make.leading.height.trailing.equalTo(nameTextField)
        }
        cityTextField.snp.makeConstraints { (make) in
            make.top.equalTo(countryTextField.snp.bottom).offset(20.0)
            make.leading.height.trailing.equalTo(countryTextField)
        }
        (type == .mail ? mailTextField : mobileTextField).snp.makeConstraints { (make) in
            make.top.equalTo(cityTextField.snp.bottom).offset(20.0)
            make.leading.height.trailing.equalTo(cityTextField)
        }
        variableTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo((type == .mail ? mailTextField : mobileTextField).snp.bottom).offset(5.0)
            make.leading.equalTo(type == .mail ? mailTextField : mobileTextField)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo((type == .mail ? mailTextField : mobileTextField).snp.bottom).offset(20.0)
            make.leading.height.trailing.equalTo(type == .mail ? mailTextField : mobileTextField)
        }
        passwordTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5.0)
            make.leading.equalTo(passwordTextField)
        }
        repeatTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20.0)
            make.leading.height.trailing.equalTo(passwordTextField)
        }
        repeatTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repeatTextField.snp.bottom).offset(5.0)
            make.leading.equalTo(repeatTextField)
        }
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(repeatTextField.snp.bottom).offset(50.0)
            make.centerX.equalTo(view)
            make.width.equalTo(view.bounds.width-50.0)
            make.height.equalTo(kStandardHeight)
        }
        termsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-20.0)
            make.centerX.equalTo(view)
        }
    }
    
    private func bind(type: OTRegisterType) {
        let mailInputPair = (
            name: nameTextField.rx.text.orEmpty.asObservable(),
            country: countryTextField.rx.text.orEmpty.asObservable(),
            city: cityTextField.rx.text.orEmpty.asObservable(),
            mail: mailTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            repeatPassword: repeatTextField.rx.text.orEmpty.asObservable(),
            registerTap: registerButton.rx.tap.asObservable()
        )
        
        let mobileInputPair = (
            name: nameTextField.rx.text.orEmpty.asObservable(),
            country: countryTextField.rx.text.orEmpty.asObservable(),
            city: cityTextField.rx.text.orEmpty.asObservable(),
            mobile: mobileTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            repeatPassword: repeatTextField.rx.text.orEmpty.asObservable(),
            registerTap: registerButton.rx.tap.asObservable()
        )
        
        let viewModel = type == .mail ?
            OTRegisterViewModel(
                input: mailInputPair,
                dependency: OTDefaultValidation.defaultValidation) :
            OTRegisterViewModel(
                input: mobileInputPair,
                dependency: OTDefaultValidation.defaultValidation)
            
            
        
        viewModel.mailValidation?.bind(to: variableTipsLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.mobileValidation?.bind(to: variableTipsLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.passwordValidation.bind(to: passwordTipsLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.repeatPasswordValidation.bind(to: repeatTipsLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.everythingValidation.bind(to: registerButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.registering.bind(to: registerButton.rx.isShowIndicator).disposed(by: disposeBag)
        viewModel.register.subscribe { (_) in
            // 跳转
            OTRoute.changeRoot(clazzName: "OTMainTabbarController", namespace: "OpalTrip")
        }.disposed(by: disposeBag)
    }

    // MARK: - Event
    @objc private func onClickBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lazy Load
    private lazy var backItem: UIBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(onClickBack))
    
    private lazy var registerTitleLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            var detailTitleConfig = OTLabel.detailTitleConfig
            detailTitleConfig.title = Bundle.localizedString(text: "register_detail_title")
            return detailTitleConfig
        })
        return label
    }()
    
    private lazy var nameTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_name")
            return config
        })
        return textField
    }()
    
    private lazy var countryTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_country")
            return config
        })
        return textField
    }()
    
    private lazy var cityTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_city")
            return config
        })
        return textField
    }()
    
    private lazy var mobileTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_mobile")
            return config
        })
        return textField
    }()
    
    private lazy var mailTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_mail")
            return config
        })
        return textField
    }()
    
    private lazy var variableTipsLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            return OTLabel.warningTipsConfig
        })
        return label
    }()
    
    private lazy var passwordTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_password")
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
    
    private lazy var repeatTextField: OTTextField = {
        let textField = OTTextField()
        textField.setupNormal(config: { () -> (OTTextField.OTTextFieldConfig) in
            var config = OTTextField.accountInsertConfig
            config.placeholder = Bundle.localizedString(text: "register_repeat")
            return config
        })
        return textField
    }()
    
    private lazy var repeatTipsLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            return OTLabel.warningTipsConfig
        })
        return label
    }()
    
    private lazy var registerButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.loginConfig
            config.title = Bundle.localizedString(text: "register")
            config.backgroundColor = .orange
            config.titleColor = .white
            return config
        })
        return button
    }()
    
    private lazy var termsLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            var config = OTLabel.tipsConfig
            config.title = Bundle.localizedString(text: "register_terms")
            config.numberOfLines = 0
            return config
        })
        return label
    }()
}
