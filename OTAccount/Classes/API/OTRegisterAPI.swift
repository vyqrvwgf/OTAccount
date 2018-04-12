//
//  OTRegsiterAPI.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/24.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import Moya

enum OTRegisterAPI {
    case mailRegister(name: String, country: String, city: String, mail: String, password: String, repeatPassword: String)
    case mobileRegister(name: String, country: String, city: String, mobile: String, password: String, repeatPassword: String)
}

extension OTRegisterAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        return "/posts"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestParameters(parameters: ["test": "test"], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
