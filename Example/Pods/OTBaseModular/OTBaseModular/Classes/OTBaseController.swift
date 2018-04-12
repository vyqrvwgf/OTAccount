//
//  OTBaseController.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/14.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit

open class OTBaseController: UIViewController {
    
    // MARK: - Public

    // MARK: - Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        edgesForExtendedLayout = .init(rawValue: 0)
    }
}

