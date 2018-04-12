//
//  OTReactiveExtension.swift
//  OpalTrip
//
//  Created by lazy on 2018/2/23.
//  Copyright © 2018年 lazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import OTUIKit

extension Reactive where Base: OTButton {
    var isShowIndicator: Binder<Bool> {
        return Binder(base) { button, isShow in
            button.isShowIndicator(isShow: isShow)
        }
    }
}
