//
//  OTMacro.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/14.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit

// String
public let kToken: String = "OpalTripUserToken"
public let kLanguage: String = "OpalTripLanguage"
public let kRememberPassword: String = "kRememberPassword"
public let kAccessAvailable: String = "kAccessAvailable"
public let kCurrentLanguage: String = "kCurrentLanguage"

// Height
public let kStandardHeight: CGFloat = 35.0
public let kStandardPadding: CGFloat = 15.0
public let kScreenWidth: CGFloat = UIScreen.main.bounds.width
public let kScreenHeight: CGFloat = UIScreen.main.bounds.height

// enum
public enum OTLanguage: String {
    case Hans = "OTHans"
    case En   = "OTEn"
}

public enum OTRegisterType: Int {
    case mail = 0
    case mobile = 1
}

public enum OTRegexExpression: String {
    case mobile = "^1[3|4|5|7|8]\\d{9}"
    case email = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    case phone = "^(\\d{3,4}-?)\\d{7,8}$"
    case link = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
    case qq = "[1-9]\\d{4,10}"
    case password = "^(?![0-9]+$)(?![A-Za-z]+$)[0-9a-zA-Z!@#$%^&*_`()-+=]{8,20}$"
}
