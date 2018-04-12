//
//  ViewController.swift
//  OTAccount
//
//  Created by sanlazy on 04/10/2018.
//  Copyright (c) 2018 sanlazy. All rights reserved.
//

import UIKit
import OTAccount
import OTMacro

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserDefaults.standard.set("OTHans", forKey: kCurrentLanguage)
        UserDefaults.standard.synchronize()
        view.addSubview(tapButton)
    }
    
    @objc private func tap() {
        let controller = OTPreLoginController()
        self.present(controller, animated: true, completion: nil)
    }

    private lazy var tapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100.0, y: 100.0, width: 100.0, height: 44.0)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
}

