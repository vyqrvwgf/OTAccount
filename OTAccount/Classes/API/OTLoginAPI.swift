//
//  OTLoginAPI.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/23.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import Moya

enum OTLoginAPI {
    case login(mobile: String, password: String)
    case register(mobile: String, password: String)
}

extension OTLoginAPI: TargetType {
    
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
        return "123".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .login(mobile, password):
            return .requestParameters(parameters: ["mobile": mobile, "password": password], encoding: URLEncoding.default)
        case let .register(mobile, password):
            return .requestParameters(parameters: ["mobile": mobile, "password": password], encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
}
