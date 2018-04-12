//
//  OTLoginViewModel.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/22.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class OTLoginViewModel {
    
    typealias OTLoginInput = (mobile: Observable<String>, password: Observable<String>, loginTap: Observable<Void>)
    typealias OTLoginDependency = OTDefaultValidation
    
    // MARK: - Public
    public let mobileValid: Observable<OTValidationResult>
    public let passwordValid: Observable<OTValidationResult>
    public let everythingValid: Observable<Bool>
    
    public let logined: Observable<Bool>
    public let logining: Observable<Bool>
    
    // MARK: - Private
    
    // MARK: - Life Cycle
    init(input: OTLoginInput, dependency: OTLoginDependency) {
        // Validation
        mobileValid = input.mobile.map { mobile in
            return dependency.mobileValidation(mobile: mobile)
        }.share(replay: 1)
        passwordValid = input.password.map({ password in
            return dependency.passwordValidation(password: password)
        }).share(replay: 1)
        everythingValid = Observable.combineLatest(mobileValid, passwordValid) { mobile, password in
            return mobile.isValid && password.isValid
        }.share(replay: 1)
        
        // loginTap
        let logining = ActivityIndicator()
        self.logining = logining.asObservable()
        
        let loginDataSource = Observable.combineLatest(input.mobile, input.password) { (mobile: $0, password: $1) }
        let provider = MoyaProvider<OTLoginAPI>()
        logined = input.loginTap.withLatestFrom(loginDataSource)
            .flatMapLatest { pair -> Observable<Bool> in
                return provider.rx.request(.login(mobile: pair.mobile, password: pair.password))
                    .asObservable()
                    .mapJSON()
                    .mapLoginResult()
                    .catchErrorJustReturn(false)
                    .trackActivity(logining)
            }.share(replay: 1)
    }
    
    deinit {
        print("deinit")
    }
}

fileprivate extension Observable {
    fileprivate func mapLoginResult() -> Observable<Bool> {
        return self.map { response -> Bool in
            guard response is [[String: Any]] else {
                throw OTError.mapLoginResultError
            }
            
            return true
        }
    }
}
