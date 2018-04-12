//
//  OTRegisterViewModel.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/24.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class OTRegisterViewModel {

    typealias OTMailRegisterInput = (name: Observable<String>, country: Observable<String>, city: Observable<String>, mail: Observable<String>, password: Observable<String>, repeatPassword: Observable<String>, registerTap: Observable<Void>)
    typealias OTMobileRegisterInput = (name: Observable<String>, country: Observable<String>, city: Observable<String>, mobile: Observable<String>, password: Observable<String>, repeatPassword: Observable<String>, registerTap: Observable<Void>)
    typealias OTRegisterDependency = OTDefaultValidation
    
    // MARK: - Public
    public var mailValidation: Observable<OTValidationResult>?
    public var mobileValidation: Observable<OTValidationResult>?
    public let passwordValidation: Observable<OTValidationResult>
    public let repeatPasswordValidation: Observable<OTValidationResult>
    public let everythingValidation: Observable<Bool>
    
    public let registering: Observable<Bool>
    public let register: Observable<Bool>
    
    // MARK: - Private
    
    // MARK: - Life Cycle
    init(input: OTMailRegisterInput, dependency: OTRegisterDependency) {
        let nameValidation: Observable<OTValidationResult> = input.name.map { name in
            return name.isEmpty ? .empty(message: "") : .success(message: "register_name_validation_success")
        }.share(replay: 1)
        
        let countryValidation: Observable<OTValidationResult> = input.country.map { country in
            return country.isEmpty ? .empty(message: "") : .success(message: "register_country_validation_success")
        }.share(replay: 1)
        
        let cityValidation: Observable<OTValidationResult> = input.city.map { city in
            return city.isEmpty ? .empty(message: "") : .success(message: "register_city_validation_success")
        }.share(replay: 1)
        
        mailValidation = input.mail.map({ mail in
            return dependency.mailValidation(mail: mail)
        }).share(replay: 1)
        
        passwordValidation = input.password.map({ password in
            return dependency.passwordValidation(password: password)
        }).share(replay: 1)
        
        repeatPasswordValidation = Observable.combineLatest(input.password, input.repeatPassword, resultSelector: dependency.repeatPasswordValidation).share(replay: 1)
        
        everythingValidation = Observable.combineLatest(nameValidation, countryValidation, cityValidation, mailValidation!, passwordValidation, repeatPasswordValidation, resultSelector: { name, country, city, mail, password, repeatPassword in
            return name.isValid && country.isValid && city.isValid && mail.isValid && password.isValid && repeatPassword.isValid
        }).share(replay: 1)
        
        let registerDataSource = Observable.combineLatest(input.name, input.country, input.city, input.mail, input.password, input.repeatPassword) { (name: $0, country: $1, city: $2, mail: $3, password: $4, repeatPassword: $5) }
        let provider = MoyaProvider<OTRegisterAPI>()
        let registering = ActivityIndicator()
        self.registering = registering.asObservable()
        register = input.registerTap.withLatestFrom(registerDataSource).flatMapLatest { pair -> Observable<Bool> in
            return provider.rx.request(.mailRegister(name: pair.name, country: pair.country, city: pair.city, mail: pair.mail, password: pair.password, repeatPassword: pair.repeatPassword))
                .asObservable()
                .mapJSON()
                .mapRegisterResult()
                .catchErrorJustReturn(false)
                .trackActivity(registering)
        }.share(replay: 1)
    }
    
    init(input: OTMobileRegisterInput, dependency: OTRegisterDependency) {
        let nameValidation: Observable<OTValidationResult> = input.name.map { name in
            return name.isEmpty ? .empty(message: "") : .success(message: "register_name_validation_success")
            }.share(replay: 1)
        
        let countryValidation: Observable<OTValidationResult> = input.country.map { country in
            return country.isEmpty ? .empty(message: "") : .success(message: "register_country_validation_success")
            }.share(replay: 1)
        
        let cityValidation: Observable<OTValidationResult> = input.city.map { city in
            return city.isEmpty ? .empty(message: "") : .success(message: "register_city_validation_success")
            }.share(replay: 1)
        
        mobileValidation = input.mobile.map({ mobile in
            return dependency.mobileValidation(mobile: mobile)
        }).share(replay: 1)
        
        passwordValidation = input.password.map({ password in
            return dependency.passwordValidation(password: password)
        }).share(replay: 1)
        
        repeatPasswordValidation = Observable.combineLatest(input.password, input.repeatPassword, resultSelector: dependency.repeatPasswordValidation).share(replay: 1)
        
        everythingValidation = Observable.combineLatest(nameValidation, countryValidation, cityValidation, mobileValidation!, passwordValidation, repeatPasswordValidation, resultSelector: { name, country, city, mail, password, repeatPassword in
            return name.isValid && country.isValid && city.isValid && mail.isValid && password.isValid && repeatPassword.isValid
        }).share(replay: 1)
        
        let registerDataSource = Observable.combineLatest(input.name, input.country, input.city, input.mobile, input.password, input.repeatPassword) { (name: $0, country: $1, city: $2, mobile: $3, password: $4, repeatPassword: $5) }
        let provider = MoyaProvider<OTRegisterAPI>()
        let registering = ActivityIndicator()
        self.registering = registering.asObservable()
        register = input.registerTap.withLatestFrom(registerDataSource).flatMapLatest { pair -> Observable<Bool> in
            return provider.rx.request(.mobileRegister(name: pair.name, country: pair.country, city: pair.city, mobile: pair.mobile, password: pair.password, repeatPassword: pair.repeatPassword))
                .asObservable()
                .mapJSON()
                .mapRegisterResult()
                .catchErrorJustReturn(false)
                .trackActivity(registering)
            }.share(replay: 1)
    }
}

fileprivate extension Observable {
    fileprivate func mapRegisterResult() -> Observable<Bool> {
        return self.map { response -> Bool in
            guard response is [[String: Any]] else {
                throw OTError.mapRegisterResultError
            }
            
            return true
        }
    }
}
