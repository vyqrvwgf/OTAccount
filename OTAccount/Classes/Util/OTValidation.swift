//
//  OTValidation.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/22.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol OTValidation {
    func mobileValidation(mobile: String) -> OTValidationResult
    func passwordValidation(password: String) -> OTValidationResult
    func repeatPasswordValidation(password: String, repeatPassword: String) -> OTValidationResult
}


