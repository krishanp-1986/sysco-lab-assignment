//
//  BindableType.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

public protocol BindableType: AnyObject {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set}
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    public func bindViewModel(_ vm: ViewModelType) {
        self.viewModel = vm
        loadViewIfNeeded()
        bindViewModel()
    }
}
