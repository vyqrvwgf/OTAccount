//
//  OTLoginDefaultValidationService.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/22.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import OTMacro
import OTUIKit

class OTDefaultValidation: NSObject, OTValidation {
    
    public static let defaultValidation: OTDefaultValidation = OTDefaultValidation()
    
    private let kMobileMinLength: Int = 11
    private let kPasswordMinLength: Int = 8
    
    func mailValidation(mail: String) -> OTValidationResult {
        if mail.count == 0 {
            return .empty(message: "")
        }
        do {
            let expression = try NSRegularExpression(pattern: OTRegexExpression.email.rawValue, options: [])
            if let matchRange = expression.firstMatch(in: mail, options: .init(rawValue: 0), range: NSMakeRange(0, mail.count))?.range, matchRange.location != NSNotFound {
                return .success(message: "mail_validate_success")
            } else {
                return .failure(message: "mail_validate_failure")
            }
        } catch {
            return .failure(message: "create_regex_failure")
        }
    }
    
    func mobileValidation(mobile: String) -> OTValidationResult {
        if mobile.count == 0 {
            return .empty(message: "")
        }
        if mobile.count < kMobileMinLength {
            return .failure(message: "mobile_length_too_short")
        }
        do {
            let expression = try NSRegularExpression(pattern: OTRegexExpression.mobile.rawValue, options: [])
            if let matchRange = expression.firstMatch(in: mobile, options: .init(rawValue: 0), range: NSMakeRange(0, (mobile as NSString).length))?.range, matchRange.location != NSNotFound {
                return .success(message: "mobile_validate_success")
            } else {
                return .failure(message: "mobile_validate_failure")
            }
        } catch {
            return .failure(message: "create_regex_failure")
        }
    }
    
    func passwordValidation(password: String) -> OTValidationResult {
        if password.count == 0 {
            return .empty(message: "")
        }
        if password.count < kPasswordMinLength {
            return .failure(message: "password_length_too_short")
        }
        do {
            let expression = try NSRegularExpression(pattern: OTRegexExpression.password.rawValue, options: [])
            if let matchRange = expression.firstMatch(in: password, options: .init(rawValue: 0), range: NSMakeRange(0, (password as NSString).length))?.range, matchRange.location != NSNotFound {
                return .success(message: "password_validate_success")
            } else {
                return .failure(message: "password_validate_failure")
            }
        } catch {
            return .failure(message: "create_regex_failure")
        }
    }
    
    func repeatPasswordValidation(password: String, repeatPassword: String) -> OTValidationResult {
        if repeatPassword.count == 0 {
            return .empty(message: "")
        }
        if repeatPassword.count < kPasswordMinLength {
            return .failure(message: "repeat_password_length_too_short")
        }
        if password != repeatPassword {
            return .failure(message: "repeat_password_not_equal_to_password")
        }
        return .success(message: "repeat_password_validate_success")
    }
}

enum OTValidationResult {
    case empty(message: String)
    case success(message: String)
    case failure(message: String)
}

extension OTValidationResult {
    var isValid: Bool {
        get {
            switch self {
            case .success:
                return true
            default:
                return false
            }
        }
    }
}

struct OTValidationColors {
    static let successColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let failureColor = UIColor.red
}

extension OTValidationResult {
    var textColor: UIColor {
        switch self {
        case .success:
            return OTValidationColors.successColor
        default:
            return OTValidationColors.failureColor
        }
    }
}

extension OTValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .success(message):
            return message
        case let .empty(message):
            return message
        case let .failure(message):
            return message
        }
    }
}

extension Reactive where Base: OTLabel {
    var validationResult: Binder<OTValidationResult> {
        return Binder(base) { label, result in
            label.setupNormal(config: { () -> (OTLabel.OTLabelConfig) in
                var config = OTLabel.tipsConfig
                config.title = result.description
                config.titleColor = result.textColor
                return config
            })
        }
    }
}
