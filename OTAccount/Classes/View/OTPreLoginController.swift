//
//  OTLoginController.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/14.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import OTBaseModular
import OTUIKit
import OTMacro

public class OTPreLoginController: OTBaseController {
    
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
        view.addSubview(hansButton)
        view.addSubview(enButton)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(loginButton)
        view.addSubview(emailRegisterButton)
        view.addSubview(wechatLoginButton)
        
        enButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view).offset(-10.0)
            make.top.equalTo(view).offset(50.0)
            make.width.equalTo(50.0)
            make.height.equalTo(20.0)
        }
        hansButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(enButton.snp.leading).offset(-10.0)
            make.top.width.height.equalTo(enButton)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(100.0)
            make.centerX.equalTo(view)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(50.0)
            make.leading.equalTo(50.0)
            make.trailing.equalTo(-50.0)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.centerY).offset(50.0)
            make.centerX.equalTo(view)
            make.width.equalTo(view.bounds.width-50.0)
            make.height.equalTo(kStandardHeight)
        }
        emailRegisterButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(30.0)
            make.centerX.width.height.equalTo(loginButton)
        }
        wechatLoginButton.snp.makeConstraints { (make) in
            make.top.equalTo(emailRegisterButton.snp.bottom).offset(10.0)
            make.centerX.width.height.equalTo(emailRegisterButton)
        }
    }
    
    private func bind() {
        let viewModel = OTPreLoginViewModel(input: (enTap: enButton.rx.tap.asObservable(),
                                                    hansTap: hansButton.rx.tap.asObservable()))

        viewModel.en.subscribe().disposed(by: disposeBag)
        viewModel.hans.subscribe().disposed(by: disposeBag)
        viewModel.isWechatLoginShow.bind(to: wechatLoginButton.rx.isHidden).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe { (_) in
            let loginController = OTLoginController()
            self.present(loginController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        emailRegisterButton.rx.tap.subscribe { (_) in
            let registerController = OTRegisterController(parameter: ["type": 0])
            self.present(registerController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        wechatLoginButton.rx.tap.subscribe { (_) in
            
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Event
    
    // MARK: - Lazy Load
    private lazy var hansButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.title = Bundle.localizedString(text: "language_hans")
            config.titleColor = .white
            config.fontSize = 15.0
            config.cornerRadius = 10.0
            config.backgroundColor = .red
            return config
        })
        return button
    }()
    
    private lazy var enButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.title = Bundle.localizedString(text: "language_en")
            config.titleColor = .white
            config.fontSize = 15.0
            config.cornerRadius = 10.0
            config.backgroundColor = .blue
            return config
        })
        return button
    }()
    
    private lazy var titleLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            return OTLabel.titleConfig
        })
        return label
    }()
    
    private lazy var descriptionLabel: OTLabel = {
        let label = OTLabel()
        label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
            var config = OTLabel.OTLabelConfig()
            config.title = Bundle.localizedString(text: "/description")
            config.titleColor = .lightGray
            config.fontSize = 11.0
            config.numberOfLines = 0
            return config
        })
        return label
    }()
    
    private lazy var loginButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            return OTButton.loginConfig
        })
        return button
    }()
    
    private lazy var emailRegisterButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            var config = OTButton.OTButtonConfig()
            config.title = Bundle.localizedString(text: "email_login")
            config.titleColor = .white
            config.fontSize = 15.0
            config.cornerRadius = 5.0
            config.backgroundColor = .orange
            return config
        })
        return button
    }()
    
    private lazy var wechatLoginButton: OTButton = {
        let button = OTButton()
        button.setupNormal(config: { () -> (OTButton.OTButtonConfig) in
            return OTButton.wechatLoginConfig
        })
        return button
    }()
}
