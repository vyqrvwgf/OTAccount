//
//  OTRoute.swift
//  OpalTrip
//
//  Created by lazy on 2018/3/16.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit

public class OTRoute: NSObject {

    // 定义三种切换控制器事件1.present 2.push 3.rootController
    public class func changeRoot(clazzName: String, namespace: String ,parameters: [String: Any]? = nil) {
        if let clazz = NSClassFromString("\(namespace).\(clazzName)") as? UIViewController.Type {
            UIApplication.shared.keyWindow?.rootViewController = clazz.init()
        }
    }
    
    public class func present(clazzName: String, namespace: String, parameter: [String: Any]? = nil, atController: UIViewController) {
        if let clazz = NSClassFromString("\(namespace).\(clazzName)") as? UIViewController.Type {
            atController.present(clazz.init(), animated: true, completion: nil)
        }
    }
    
    public class func push(clazzName: String, namespace: String, parameter: [String: Any]? = nil, atController: UIViewController) {
        if let clazz = NSClassFromString("\(namespace).\(clazzName)") as? UIViewController.Type {
            atController.navigationController?.pushViewController(clazz.init(), animated: true)
        }
    }
}
