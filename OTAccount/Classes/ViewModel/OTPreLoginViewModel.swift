//
//  OTPreLoginViewModel.swift
//  OpalTrip
//
//  Created by lazy on 2018/4/3.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OTPreLoginViewModel {

    // MARK: - Public
    internal let en: Observable<Void>
    internal let hans: Observable<Void>
    
    internal let isWechatLoginShow: Observable<Bool>
    
    // MARK: - Private
    typealias OTPreLoginInput = (enTap: Observable<Void>, hansTap: Observable<Void>)
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    init(input: OTPreLoginInput) {
        en = input.enTap.map { (_) in
//            OTUserSetting.currentSetting.setLanguage(language: .En)
        }.share(replay: 1)
        
        hans = input.hansTap.map({ (_) in
//            OTUserSetting.currentSetting.setLanguage(language: .Hans)
        }).share(replay: 1)
        
        isWechatLoginShow = Observable<Bool>.create({ (observer) -> Disposable in
            // 监测是否未安装wechat
            observer.on(.next(true))
            return Disposables.create()
        })
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: - Custom Method
    
    // MARK: - Event
    
    // MARK: - Lazy Load
}
